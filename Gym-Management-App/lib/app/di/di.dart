import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:login/app/shared_prefs/token_shared_prefs.dart';
import 'package:login/core/network/api_service.dart';
import 'package:login/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:login/features/auth/data/repository/auth_remote_repository.dart';
import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:login/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:login/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:login/features/cart/domain/repositories/cart_repository.dart';
import 'package:login/features/cart/domain/usecases/add_to_cart.dart';
import 'package:login/features/cart/domain/usecases/get_cart_items.dart';
import 'package:login/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/usecases/get_all_categories.dart';
import 'package:login/features/category/presentation/bloc/category_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/hive_service.dart';
import '../../features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import '../../features/auth/data/repository/auth_local_repository.dart';
import '../../features/auth/domain/use_case/login_usecase.dart';
import '../../features/auth/domain/use_case/register_user_usecase.dart';
import '../../features/auth/presentation/view_model/login/login_bloc.dart';
import '../../features/auth/presentation/view_model/signup/register_bloc.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';

final getIt = GetIt.instance;

/// ✅ Initialize all dependencies before using them
Future<void> initAllDependencies() async {
  _initHiveService();
  _initApiService();
  await _initSharedPreferences();
  _initHomeDependencies();
  _initRegisterDependencies();
  _initLoginDependencies();
}

/// ✅ Setup Cart Dependencies
void setupCartDependencies() {
  // ✅ Register HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ✅ Register Cart Remote Data Source
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  // ✅ Register Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
  );

  // ✅ Register Use Cases
  getIt.registerLazySingleton<GetCartItemsUseCase>(
    () => GetCartItemsUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );

  // ✅ Register Bloc
}

Future<void> initDependencies() async {
  _initHiveService();
  _initApiService();
  await _initSharedPreferences();
  _initHomeDependencies();
  _initRegisterDependencies();
  _initLoginDependencies();
  _initCategoryDependencies(); // ✅ Register CategoryBloc
}

void _initCategoryDependencies() {
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<CategoryRepositoryImpl>(
    () => CategoryRepositoryImpl(
        remoteDataSource: getIt<CategoryRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetAllCategories>(
    () => GetAllCategories(getIt<CategoryRepositoryImpl>()),
  );

  getIt.registerLazySingleton<CategoryBloc>(
    () => CategoryBloc(getAllCategories: getIt<GetAllCategories>()),
  );
}

/// ✅ Initialize API Service before using it
void _initApiService() {
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

/// ✅ Initialize Hive Service
void _initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

/// ✅ Register Shared Preferences
Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

/// ✅ Register Authentication Dependencies
void _initRegisterDependencies() {
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDatasource>()),
  );

  getIt.registerLazySingleton<RegisterUseUseCase>(
    () => RegisterUseUseCase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt(),
      uploadImageUsecase: getIt(),
    ),
  );
}

/// ✅ Register Home Dependencies
void _initHomeDependencies() {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

/// ✅ Register Login Dependencies
void _initLoginDependencies() {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}
