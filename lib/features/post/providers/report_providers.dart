import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/data/data_source/remote_report_data_source.dart';
import 'package:sodong_app/features/post_list/presentation/providers/post_providers.dart';

final _reportDataSource = Provider(
  (ref) => RemoteReportDataSource(ref.read(firestoreProvider)),
);
