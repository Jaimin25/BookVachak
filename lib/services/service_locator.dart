import 'package:audio_service/audio_service.dart';
import 'package:bookvachak/services/audio_handler.dart';
import 'package:bookvachak/widgets/Player/page_manager.dart';

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  AudioHandler adh =
      getIt.registerSingleton<AudioHandler>(await initAudioService());
  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager(adh: adh));
}
