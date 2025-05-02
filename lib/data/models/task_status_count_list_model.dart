import 'package:task_manager_app/data/models/task_status_count_model.dart';

class TaskStatusCountListModel{
  late final String status;
  late final List<TaskStatusCountModel> statusCountList;

  TaskStatusCountListModel.fromJson(Map<String,dynamic> jsonData){
    status=jsonData['status'];
    if(jsonData['data']!=null){
      statusCountList=[];
      jsonData['data'].forEach((e){
        statusCountList.add(TaskStatusCountModel.fromJson(e));
      });

    }
    else{
      statusCountList=[];
    }
  }
}
