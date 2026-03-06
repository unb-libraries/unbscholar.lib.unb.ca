<?php

namespace Dockworker\Robo\Plugin\Commands;

use Consolidation\AnnotatedCommand\CommandData;
use Dockworker\DockworkerDaemonCommands;
use Dockworker\Docker\DeployedLocalResourcesTrait;
use Dockworker\Docker\DockerComposeTrait;
use Dockworker\Docker\DockerContainerExecTrait;
use Dockworker\IO\DockworkerIOTrait;

/**
 * Provides commands for building and deploying the DSpace Frontend application.
 */
class DSpaceFrontendDeploymentCommands extends DockworkerDaemonCommands
{
    use DeployedLocalResourcesTrait;
    use DockerComposeTrait;
    use DockerContainerExecTrait;
    use DockworkerIOTrait;

    /**
     * Provides error log triggers and exceptions for the DSpace Frontend application.
     *
     * @hook on-event dockworker-deployment-log-error-exceptions
     *
     * @return mixed[]
     *   The error log exceptions.
     */
    public function provideErrorLogConfiguration(): array
    {
        return [
            [],
            array_values(
                [
                  'rules skipped due to selector errors' => 'CSS errors, not critical',
                ]
            ),
        ];
    }

    /**
     * Informs the user of useful information after a successful deployment.
     *
     * For the sake of simplicity, as this is a hook (and we know it is local)
     * we bypass the container discovery process and just send the ULI command
     * to the container directly.
     *
     * @param mixed $result
     *   The result of the command.
     * @param \Consolidation\AnnotatedCommand\CommandData $commandData
     *   The command data.
     *
     * @hook post-command application:deploy
     */
    public function displayAngularlLocalLinks(
        $result,
        CommandData $commandData,
        $action = 'Deployment'
    ): void {
        // Hooks don't fire for other hooks, so we have to initialize resources.
        $this->initOptions();
        $this->initDockworkerIO();
        $this->preInitDockworkerPersistentDataStorageDir();
        $this->registerDockerCliTool($this->dockworkerIO);

        $this->dockworkerIO->title("$action Success!");
        $this->dockworkerIO->block(
            $this->formatLinksBlock()
        );
    }

    /**
     * Formats the links block for the user.
     *
     * @TODO: This should be moved to a template.
     *
     * @param string $login_link
     *   The login link to display.
     *
     * @return string[]
     *   The formatted links block.
     */
    protected function formatLinksBlock(): array
    {
        $local_links = [];
        $local_links[] = sprintf(
            'Visit the deployed site at: http://localhost:9988'
        );
        return $local_links;
    }
}
