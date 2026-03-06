<?php

namespace Dockworker\Robo\Plugin\Commands;

use Dockworker\Docker\DockerContainerExecTrait;
use Dockworker\DockworkerDaemonCommands;

/**
 * Provides commands for compiling the DSpace frontend themes.
 */
class DspaceThemeCommands extends DockworkerDaemonCommands
{
    use DockerContainerExecTrait;

    /**
     * Compiles the DSpace frontend themes in development (local).
     *
     * @param mixed[] $options
     *   The options passed to the command.
     *
     * @option string $env
     *   The environment to compile the themes in.
     *
     * @command dspace:theme:compile
     * @aliases theme-build
     * @usage --env=prod
     */
    public function compileDspaceThemes(
        array $options = [
            'env' => 'local',
        ]
    ): void {
        $cmd = [
            '/scripts/updateThemes.sh',
        ];
        $this->executeContainerCommand(
            $options['env'],
            $cmd,
            $this->dockworkerIO,
            'Compiling DSpace themes',
            sprintf(
                'Compiling DSpace themes in %s',
                $options['env']
            )
        );
    }
}
