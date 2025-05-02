import 'package:get/get.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCancelledTaskInProgress = false;
  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _getCancelledTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _cancelledTaskList = taskListModel.taskList;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCancelledTaskInProgress = false;
    update();
    return isSuccess;
  }
}
