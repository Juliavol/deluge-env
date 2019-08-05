import hudson.security.HudsonPrivateSecurityRealm
import jenkins.install.InstallState
import jenkins.model.Jenkins
import hudson.security.GlobalMatrixAuthorizationStrategy


def instance = Jenkins.getInstanceOrNull()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def adminUsername = System.getenv('JENKINS_ADMIN_USERNAME') ?: '${jenkins_admin_user}'
def adminPassword = System.getenv('JENKINS_ADMIN_PASSWORD') ?: '${jenkins_admin_password}'
hudsonRealm.createAccount(adminUsername, adminPassword)

instance.setSecurityRealm(hudsonRealm)
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, System.getenv('JENKINS_ADMIN_USERNAME') ?: 'admin')
instance.setAuthorizationStrategy(strategy)

instance.save()