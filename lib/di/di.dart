import 'package:flutter_camera/screen/provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CameraListProvider = ChangeNotifierProvider((ref) => ImageListModel());
