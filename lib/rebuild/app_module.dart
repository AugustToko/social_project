import 'package:dartin/dartin.dart';
import 'package:shared/mvvm/helper/shared_preferences.dart';
import 'package:shared/mvvm/model/repository.dart';
import 'package:social_project/rebuild/viewmodel/editor_page_provider.dart';
import 'package:social_project/rebuild/viewmodel/login_page_provide.dart';
import 'package:social_project/rebuild/viewmodel/profile_coolapk_provider.dart';
import 'package:social_project/rebuild/viewmodel/wordpress_page_provider.dart';

/// ViewModel 模块
///
/// 定义ViewModel的构造方式
final viewModelModule = Module([
  factory<LoginPageProvider>(({params}) => LoginPageProvider(get())),
  factory<EditorPageProvider>(({params}) => EditorPageProvider()),
  factory<ProfileCoolApkPageProvider>(
      ({params}) => ProfileCoolApkPageProvider()),
  factory<WordPressPageProvider>(({params}) => WordPressPageProvider()),
]);

/// Repository 模块
///
/// 定义Repository 的构造方式
final repoModule = Module([
  factory<WordPressMvvmRepo>(({params}) => WordPressMvvmRepo(get(), get())),
]);

/// Remote 模块
///
/// 定义各网络接口服务的构造方式
final remoteModule = Module([
  factory<WordPressService>(({params}) => WordPressService()),
]);

/// Local 模块
///
/// 定义数据库层及SharedPreference/KV等等本地存储的构造方式
final localModule = Module([
  single<SpUtil>(({params}) => spUtil),
]);

///// AuthInterceptor
/////
///// 添加header认证
//class AuthInterceptor extends Interceptor {
//  @override
//  onRequest(RequestOptions options) {
//    final token = spUtil.getString(KEY_TOKEN);
//    options.headers
//        .update("Authorization", (_) => token, ifAbsent: () => token);
//    return super.onRequest(options);
//  }
//}
//
//final dio = Dio()
//  ..options = BaseOptions(
//      baseUrl: 'https://blog.geek-cloud.top/wp-json/jwt-auth/v1/token',
//      connectTimeout: 30,
//      receiveTimeout: 30)
//  ..interceptors.add(AuthInterceptor())
//  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

final appModule = [viewModelModule, repoModule, remoteModule, localModule];

SpUtil spUtil;

/// init
///
/// 初始化 [spUtil] 并启动[DartIn]
init() async {
  spUtil = await SpUtil.getInstance();
  // DartIn start
  startDartIn(appModule);
}
