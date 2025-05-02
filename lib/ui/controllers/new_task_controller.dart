import 'package:get/get.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class NewTaskController extends GetxController {
  bool _getNewTaskInProgress = false;
  bool get getNewTaskInProgress => _getNewTaskInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TaskModel> _newTastList = [];
  List<TaskModel> get newTastList => _newTastList;
  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _newTastList = taskListModel.taskList;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTaskInProgress = false;
    update();
    return isSuccess;
  }
}
