<?php

namespace Dockworker\Robo\Plugin\Commands;

use Dockworker\Robo\Plugin\Commands\DockworkerLocalCommands;
use Robo\Robo;

/**
 * Defines the commands used to interact with a local Dspace frontend.
 */
class DSpaceFrontendLocalCommands extends DockworkerLocalCommands {

  /**
   * Compiles Dspace frontend themes.
   *
   * @hook post-command theme:build-all
   */
  public function setBuildDspaceFrontEndThemes() {
    $container_name = Robo::Config()->get('dockworker.application.name');
    exec(
      "docker inspect -f {{.State.Running}} $container_name 2>&1",
      $output,
      $return_code
    );

    if ($return_code == 0 && $output[0] == "true") {
      if (empty($user_name)) {
        $this->taskDockerExec($container_name)
          ->interactive()
          ->exec(
            '/scripts/updateThemes.sh'
          )
          ->run();
      }
    }
    else {
      $this->say('Skipping theme build, container isn\'t ready.');
    }
  }

}
