class JakeDataResponse {
  late String status, message;
  late List<JakeData> list;
  JakeDataResponse.fromJson(json) {
    this.status = 'SUCCESS';
    list = [];
    for (var item in json) {
      list.add(JakeData.fromJson(item));
    }
  }
  JakeDataResponse.fromError(error) {
    this.status = 'FAILURE';
    this.message = error;
  }
}

class JakeData {
  late String name, description, language;
  late int openIssues, watchers;
  JakeData.fromJson(json) {
    if (json["name"] != null) {
      this.name = json["name"];
    } else {
      this.name = "unknown";
    }
    if (json["description"] != null) {
      this.description = json["description"];
    } else {
      this.description = "unknown";
    }
    if (json["open_issues"] != null) {
      this.openIssues = json["open_issues"];
    } else {
      this.openIssues = 0;
    }
    if (json["watchers"] != null) {
      this.watchers = json["watchers"];
    } else {
      this.watchers = 0;
    }

    if (json["language"] != null) {
      this.language = json["language"];
    } else {
      this.language = "unknown";
    }
  }
}
