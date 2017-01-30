import "dart:io";

import "package:legit/legit.dart";

Directory localData = new Directory(Platform.environment["HOME"] + "/.dotdart/");

main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage: dotdart <command> [args]");
    exit(0);
  }

  await createLocalDirectory();

  String cmd = args[0];
  args = args.skip(1).toList();
  switch (cmd) {
    case "install":
      if (args.length == 0) {
        print("Usage: dotdart install <repos>");
        exit(0);
      }
      for (String repo in args) {
        install(repo);
      }
      break;
  }
}

createLocalDirectory() async {
  await localData.create();
}

install(String repo) async {
  if (repo.indexOf("/") == -1) {
    print("Invalid repository.");
    return;
  }
  String folderName = repo.replaceAll("/", ".");
  String path = "${localData.path}$folderName";
  var git = new GitClient.forDirectory(new Directory(path));

  if (await git.isRepository()) {
    print("$repo has already been installed.");
    return;
  } else {
    await git.clone("https://github.com/$repo.git");
  }
}
