# Git Branches
## Creating a new Git branch
1. Create a new branch.
```bash
$ git branch [branchName]
```
2. Verify it was created: (Retrieves a list of all local branches, current branch highlighted with an asterisk)
```bash
$ git branch
```
3. Switch to the new branch.
```bash
$ git checkout newBranch
```
## Creating a new branch and switching to it immediately
1. Two methods create a new branch from the current branch.
```bash
$ git checkout -b maketecheasier
$ git switch -c mte2
```
2. To create a new branch from a different branch.
```bash
$ git checkout -b [newBranch] [targetBranch]
```
## Creating a branch from a specific commit
1. Get a list of recent commits with their hash values.
```bash
$ git log --oneline
```
2. Use the hash of the commit to create a new branch based on it.
```bash
$ git branch [newBranch] [commitHash]
```
## Creating a remote branch and pushing it to GitHub
```bash
$ git branch --track newBranch origin/remoteBranch
```
## Creating a git branch in a remote repository
```bash
$ git push -u remoteRepo localBranch	# origin/localBranch
```
## Deleting git branches
1. For a local Git branch you've already merged and pushed to a remote repository.
```bash
$ git branch -d branchName
```
2. To delete a branch no matter whether it’s merged or not.
```bash
$ it branch -D branchName
```
## Rename a local branch in Git
1. List all the branches in your repository.
```bash
$ git branch -a
```
2. Switch to the branch that needs to be renamed.
```bash
$ git switch branchName
```
3. After switching to the branch you want to rename, change its name.
```bash
$ git branch -m [updatedBranchName]
```
4. Confirm the branch rename.
```bash
$ git branch -a
```
## Rename a remote branch in Git
1. check the list of branches to make sure the branch is named correctly.
```bash
$ git branch -a
$ git branch -r		# list only remote branches
```
2. Remove the old branch name from the remote repository.
```bash
$ git push [remoteRepository] --delete [oldBranchName]
```
3. Once the old branch is deleted, push the renamed branch to the remote and set it to track the upstream branch.
```bash
$ git push -u origin newBranchName
```
4. List the remote branches to ensure that the branch has been successfully renamed.
```bash
$ git branch -r
```
