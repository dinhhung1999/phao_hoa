import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../constants/firestore_paths.dart';

class StaffMember {
  final String uid;
  final String name;
  final String email;
  final bool active;
  final DateTime? createdAt;

  const StaffMember({
    required this.uid,
    required this.name,
    required this.email,
    required this.active,
    this.createdAt,
  });

  factory StaffMember.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return StaffMember(
      uid: doc.id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      active: data['active'] == true,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }
}

class StaffService {
  StaffService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Once owner_uids is present it replaces the legacy owner_uid field.
  static List<String> ownerUids(Map<String, dynamic>? config) {
    if (config == null) return const [];
    if (config.containsKey('owner_uids')) {
      final value = config['owner_uids'];
      if (value is! List) return const [];
      return value
          .whereType<String>()
          .where((uid) => uid.trim().isNotEmpty)
          .toList();
    }
    final legacy = config['owner_uid'];
    return legacy is String && legacy.trim().isNotEmpty ? [legacy] : const [];
  }

  DocumentReference<Map<String, dynamic>> get accessControl => _firestore
      .collection(FirestorePaths.appConfig)
      .doc(FirestorePaths.accessControlDoc);

  CollectionReference<Map<String, dynamic>> get profiles =>
      _firestore.collection(FirestorePaths.staffProfiles);

  Stream<List<StaffMember>> watchStaff() =>
      profiles.snapshots().map((snapshot) {
        final members = snapshot.docs.map(StaffMember.fromDocument).toList();
        members.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        return members;
      });

  Future<void> createStaff({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedName.isEmpty ||
        normalizedEmail.isEmpty ||
        password.length < 6) {
      throw ArgumentError('Nhập tên, email và mật khẩu ít nhất 6 ký tự.');
    }

    // A separate app keeps the owner's Auth session intact while creating a user.
    final app = await Firebase.initializeApp(
      name: 'staff-registration-${DateTime.now().microsecondsSinceEpoch}',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth? secondaryAuth;
    User? createdUser;
    try {
      secondaryAuth = FirebaseAuth.instanceFor(app: app);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      createdUser = credential.user;
      if (createdUser == null) throw StateError('Không tạo được tài khoản.');
      await createdUser.updateDisplayName(normalizedName);
      await profiles.doc(createdUser.uid).set({
        'name': normalizedName,
        'email': normalizedEmail,
        'role': 'employee',
        'active': true,
        'created_at': FieldValue.serverTimestamp(),
        'created_by_uid': _auth.currentUser?.uid,
      });
    } catch (_) {
      // If profile creation fails, remove the newly created Auth user while
      // the secondary session still has permission to delete itself.
      if (createdUser != null) {
        try {
          await createdUser.delete();
        } catch (_) {
          throw StateError(
            'Tài khoản Auth đã tạo nhưng không lưu được hồ sơ. '
            'Hãy xóa UID ${createdUser.uid} trong Firebase Console.',
          );
        }
      }
      rethrow;
    } finally {
      try {
        await secondaryAuth?.signOut();
      } catch (_) {
        // The temporary app is removed below even if sign-out fails.
      }
      try {
        await app.delete();
      } catch (_) {
        // Account/profile creation has already completed at this point.
      }
    }
  }

  Future<void> updateName(StaffMember member, String name) =>
      profiles.doc(member.uid).update({'name': name.trim()});

  Future<void> setActive(StaffMember member, bool active) =>
      profiles.doc(member.uid).update({'active': active});

  Future<void> sendPasswordReset(StaffMember member) =>
      _auth.sendPasswordResetEmail(email: member.email);
}
