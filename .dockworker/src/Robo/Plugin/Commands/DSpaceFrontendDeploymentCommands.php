<?php

namespace Dockworker\Robo\Plugin\Commands;

use Dockworker\Robo\Plugin\Commands\DockworkerDeploymentCommands;

/**
 * Defines commands to interact with a deployed DSpace Frontend application.
 */
class DSpaceFrontendDeploymentCommands extends DockworkerDeploymentCommands {

  /**
   * Provides Dspace Frontend related new deployed ignored log exceptions.
   *
   * @hook on-event dockworker-deployment-log-error-exceptions
   */
  public function getFrontEndDspaceErrorLogDeploymentExceptions() {
    return [
      'rules skipped due to selector errors' => 'CSS errors, not critical',
    ];
  }

  /**
   * Provides Dspace Frontend related new local ignored log exceptions.
   *
   * @hook on-event dockworker-local-log-error-exceptions
   */
  public function getFrontEndDspaceErrorLogLocalExceptions() {
    return [
      'rules skipped due to selector errors' => 'CSS errors, not critical',
    ];
  }

}
