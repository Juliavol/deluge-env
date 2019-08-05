import jenkins.model.Jenkins
import hudson.plugins.git.*;

def scm = new GitSCM("https://github.com/Juliavol/deluge.git")
scm.branches = [new BranchSpec("*/develop")];
def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")

def parent = Jenkins.instance
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, "deluge-pipeline")
job.definition = flowDefinition
Jenkins.get().add(job, job.name);
