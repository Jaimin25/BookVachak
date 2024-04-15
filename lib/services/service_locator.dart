import 'package:bookvachak/services/audio_handler.dart';
import 'package:bookvachak/widgets/Player/page_manager.dart';

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<MyAudioHandler> setupServiceLocator() async {
  // services
  MyAudioHandler adh =
      getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager(adh: adh));

  return adh;
}
