import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/progress_task_controller.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';

import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskController _progressTaskController = Get.find<ProgressTaskController>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProgressTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getProgressTaskInProgress==false,
            replacement: CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.progressTaskList.length,
              itemBuilder: (context, index) {
                 return  TaskCard(taskStatus: TaskStatus.progress,taskModel: controller.progressTaskList[index],refreshList: _getAllProgressTaskList,);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        }
      ),
    );
  }
  Future<void> _getAllProgressTaskList() async {
    final bool isSuccess =
    await _progressTaskController.getProgressTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _progressTaskController.errorMessage!);
    }
  }
}
