import 'package:get/get.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTaskInProgress = false;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;
  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _getCompletedTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCompletedTaskInProgress = false;
    update();
    return isSuccess;
  }
}
