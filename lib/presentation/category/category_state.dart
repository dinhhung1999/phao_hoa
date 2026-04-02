part of 'category_bloc.dart';

@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.loaded(List<Product> products) = _Loaded;
  const factory CategoryState.actionSuccess(String message) = _ActionSuccess;
  const factory CategoryState.error(String message) = _Error;
}
