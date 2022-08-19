# Local Development Procedures
Local development is possible in the ```local``` branch, not ```dev/prod```.

In that branch, a simple ```dockworker start-over``` is enough to spin up a local development instance. Some quick notes:

* The address to the interface is http://localhost:9988, not the local-unbscholar.* URI you might expect.
* On ```start-over```, sample content is automatically imported each time, and an administrator account is created:
  * user: dspace@local.admin.com
  * pass: localdevadminpass
* ```start-over```, not ```rebuild``` - UNBScholar is unique in that it does not support several of our usual dockworker commands. local:rebuild is unlikely to ever work well.
* The configured theme is ```custom```, and all changes should be made to it. Its location in the repository is ```/build/src/themes/custom```.
* The theme ```custom``` inherits from, ```dspace```, and ```dspace``` has been left in the repository to use as a reference for variables and components.
* Once deployed locally, any changes to the _themes_ or _assets_ can then be updated with the usual: ```dockworker theme:build-all```
