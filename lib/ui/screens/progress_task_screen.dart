import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTastList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getProgressTaskInProgress==false,
        replacement: CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemCount: _progressTastList.length,
          itemBuilder: (context, index) {
             return  TaskCard(taskStatus: TaskStatus.progress,taskModel: _progressTastList[index],refreshList: _getAllProgressTaskList,);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }
  Future<void> _getAllProgressTaskList() async {
    _getProgressTaskInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTastList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getProgressTaskInProgress = false;
    setState(() {});
  }
}
