import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/completed_task_controller.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';

import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController _completedTaskController = Get.find<CompletedTaskController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CompletedTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCompletedTaskInProgress == false,
            replacement: CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskStatus: TaskStatus.completed,
                  taskModel: controller.completedTaskList[index],
                  refreshList: _getAllCompletedTaskList,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        }
      ),
    );
  }

  Future<void> _getAllCompletedTaskList() async {
    final bool isSuccess =
        await _completedTaskController.getCompletedTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _completedTaskController.errorMessage!);
    }
  }
}
