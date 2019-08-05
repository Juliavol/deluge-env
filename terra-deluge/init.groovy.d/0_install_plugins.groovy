import hudson.model.*
import hudson.remoting.Future
import jenkins.model.*
import java.util.concurrent.TimeUnit

{ String msg = getClass().protectionDomain.codeSource.location.path ->
    println "--> ${msg}"

    Jenkins.instance.getPluginManager().getPlugins()
    Jenkins.instance.getUpdateCenter().updateAllSites()

    def Map<String,Future<UpdateCenter.UpdateCenterJob>> updateCenterJobs = [:]
    /* plugins */ [
            'authentication-tokens',
            'build-monitor-plugin',
            'build-name-setter',
            'build-with-parameters',
            'cloudbees-folder',
            'credentials',
            'docker-workflow',
            'durable-task',
            'git',
            'github',
            'gravatar',
            'greenballs',
            'groovy',
            'groovy-postbuild',
            'job-dsl',
            'ldap',
            'matrix-auth',
            'matrix-project',
            'parameterized-trigger',
            'pipeline-utility-steps',
            'project-description-setter',
            'rebuild',
            'ssh-agent',
            'ssh-credentials',
            'timestamper',
            'workflow-aggregator',
            'workflow-multibranch',
            'ec2',
            'blueocean',
            'kubernetes',
            'kubernetes-cd',
            'kubernetes-credentials'
    ].each { pluginId ->
        try {
            def plugin = Jenkins.instance.getUpdateCenter().getPlugin(pluginId)
            if (!plugin.installed || (!plugin.installed.isPinned() && plugin.installed.hasUpdate())) {
                updateCenterJobs[pluginId] = plugin.deploy(true)
            }
        } catch (Exception x) {
            x.printStackTrace()
        }
    }

    updateCenterJobs.each { entry ->
        entry.getValue().get(5, TimeUnit.MINUTES)
    }

    if (updateCenterJobs.size() > 0) {
        Jenkins.instance.safeRestart()
    }

    println "--> ${msg} ... done"
} ()
