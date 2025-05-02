import 'package:get/get.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class ProgressTaskController extends GetxController {
  bool _getProgressTaskInProgress = false;
  bool get getProgressTaskInProgress => _getProgressTaskInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TaskModel> _progressTaskList = [];
  List<TaskModel> get progressTaskList => _progressTaskList;
  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _getProgressTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskInProgress = false;
    update();
    return isSuccess;
  }
}
