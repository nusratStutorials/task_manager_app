import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';


enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel, required this.refreshList,
  });
  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(widget.taskModel.description),
            Text('Date: ${widget.taskModel.createdDate}'),
            Row(
              children: [
                Chip(
                  label: Text(widget.taskModel.status),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Visibility(
                  visible: _inProgress==false,
                  replacement: const Center(
                      child: CenteredCircularProgressIndicator()
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: _deleteTask, icon: Icon(Icons.delete)),
                      IconButton(
                        onPressed: _showUpdateStatusDialog,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    late Color color;
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  if(isSelected('New')) return;
                  _popDialog();
                  _changeTaskStatus('New');
                },
                leading: Icon(Icons.new_label),
                title: Text('New'),
                trailing:
                    isSelected('New')
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
              ),
              ListTile(
                onTap: () {
                  if(isSelected('Progress')) return;
                  _popDialog();
                  _changeTaskStatus('Progress');
                },
                leading: Icon(Icons.access_time),
                title: Text('Progress'),
                trailing:
                    isSelected('Progress')
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
              ),
              ListTile(
                onTap: () {
                  if(isSelected('Completed')) return;
                  _popDialog();
                  _changeTaskStatus('Completed');
                },
                leading: Icon(Icons.check_circle),
                title: Text('Completed'),
                trailing:
                    isSelected('Completed')
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
              ),
              ListTile(
                onTap: () {
                  if(isSelected('Cancelled')) return;
                  _popDialog();
                  _changeTaskStatus('Cancelled');
                },
                leading: Icon(Icons.cancel),
                title: Text('Cancelled'),
                trailing:
                    isSelected('Cancelled')
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _popDialog() {
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;
  Future<void> _changeTaskStatus(String status) async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    _inProgress = false;
    if (response.isSuccess) {
      widget.refreshList();

    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
  Future<void> _deleteTask() async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );
    _inProgress = false;
    if (response.isSuccess) {
      widget.refreshList();

    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
}
