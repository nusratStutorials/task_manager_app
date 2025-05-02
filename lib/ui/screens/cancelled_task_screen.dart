import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';

import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskController _cancelledTaskController = Get.find<CancelledTaskController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CancelledTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCancelledTaskInProgress==false,
            replacement: CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.cancelledTaskList.length,
              itemBuilder: (context, index) {
                 return  TaskCard(taskStatus: TaskStatus.cancelled,taskModel: controller.cancelledTaskList[index], refreshList: _getCancelledTaskList,);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        }
      ),
    );
  }
  Future<void> _getCancelledTaskList() async {
    final bool isSuccess = await _cancelledTaskController.getCancelledTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _cancelledTaskController.errorMessage!);
    }

  }
}
