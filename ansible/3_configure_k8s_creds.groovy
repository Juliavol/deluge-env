// k8s master i needs to be configured with ansible and not with terraform


import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.plugins.credentials.domains.Domain
import com.microsoft.jenkins.kubernetes.credentials.*
import jenkins.model.Jenkins

Jenkins instance = Jenkins.getInstanceOrNull()
//def store = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def ksiource = new KubeconfigCredentials.FileOnKubernetesMasterKubeconfigSource( "{{ k8s_master_ip }}", "Session3_jenkins_keyPair")

def b = new KubeconfigCredentials(
        com.cloudbees.plugins.credentials.CredentialsScope.GLOBAL,
        'kube-config',
        'foaas kube config',
        ksiource
)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), b)
