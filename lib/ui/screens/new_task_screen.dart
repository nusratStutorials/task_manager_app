import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_status_count_list_model.dart';
import 'package:task_manager_app/data/models/task_status_count_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controllers/new_task_controller.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _getStatusCountInProgress == false,
              replacement: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CenteredCircularProgressIndicator(),
              ),
              child: _buildSummarySection(),
            ),
            GetBuilder<NewTaskController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.getNewTaskInProgress == false,
                  replacement: SizedBox(
                    height: 300, // adjust based on your layout
                    child: CenteredCircularProgressIndicator(),
                  ),
                  child: ListView.separated(
                    itemCount: controller.newTastList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskStatus: TaskStatus.sNew,
                        taskModel: controller.newTastList[index],
                        refreshList: () {
                          _getAllNewTaskList();
                          _getAllTaskStatusCount();
                        },
                      );
                    },
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTask,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index) {
            return SummaryCard(
              title: _taskStatusCountList[index].status,
              count: _taskStatusCountList[index].count,
            );
          },
        ),
      ),
    );
  }

  void _onTapAddNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
    );
  }

  Future<void> _getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});
      _taskStatusCountList = taskStatusCountListModel.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getStatusCountInProgress = false;
    setState(() {});
  }

  Future<void> _getAllNewTaskList() async {
    final bool isSuccess = await _newTaskController.getNewTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _newTaskController.errorMessage!);
    }
  }
}
