import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/data/data_source/remote_report_data_source.dart';
import 'package:sodong_app/features/post/data/repositories/remote_report_repository.dart';
import 'package:sodong_app/features/post/domain/use_case/report_post_use_case.dart';
import 'package:sodong_app/features/post/presentation/view_models/post_detail_view_model.dart';
import 'package:sodong_app/features/post_list/presentation/providers/post_providers.dart';

final _reportDataSource = Provider(
  (ref) => RemoteReportDataSource(ref.read(firestoreProvider)),
);

final _reportRepository = Provider(
  (ref) => RemoteReportRepository(ref.read(_reportDataSource)),
);

final _reportPostUseCase = Provider(
  (ref) => ReportPostUseCase(ref.read(_reportRepository)),
);

final reportViewModelProvider = Provider(
  (ref) => ReportViewModel(ref.read(_reportPostUseCase)),
);
