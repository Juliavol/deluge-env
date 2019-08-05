import com.amazonaws.services.ec2.model.InstanceType
import hudson.model.*
import hudson.plugins.ec2.AmazonEC2Cloud
import hudson.plugins.ec2.EC2Tag
import hudson.plugins.ec2.SlaveTemplate
import hudson.plugins.ec2.UnixData
import jenkins.model.Jenkins

// parameters
def SlaveTemplateUsEast1Parameters = [
//        ami:                      'ami-072a9c65c524270ca',
        ami:                      'ami-0ef62b8097bad8702',
        associatePublicIp:        false,
        connectBySSHProcess:      false,
        connectUsingPublicIp:     false,
        customDeviceMapping:      '',
        deleteRootOnTermination:  true,
        description:              'Jenkins slave EC2 US East 1',
        ebsOptimized:             false,
        iamInstanceProfile:       '',
        idleTerminationMinutes:   '5',
        initScript:               '',
        instanceCapStr:           '2',
        jvmopts:                  '',
        labelString:              'jenkins_micro_aws_slave',
        launchTimeoutStr:         '',
        numExecutors:             '2',
        remoteAdmin:              'ubuntu',
        remoteFS:                 '',
        securityGroups:           '${jenkins_ec2_sg}',
        stopOnTerminate:          false,
        subnetId:                 '${jenkins_ec2_subnet}',
        tags:                     new EC2Tag('Name', 'deluge-jenkins-slave'),
        tmpDir:                   '',
        type:                     't2.micro',
        useDedicatedTenancy:      false,
        useEphemeralDevices:      true,
        usePrivateDnsName:        true,
        userData:                 '',
        zone:                     'us-east-1a'
]

def AmazonEC2CloudParameters = [
        cloudName:      'tf-cluster-deluge',
        credentialsId:  'jenkins-aws-key',
        instanceCapStr: '2',
        privateKey:     '''${jenkins_ssh_key}''',
        region: 'us-east-1',
        useInstanceProfileForCredentials: true
]

//def AWSCredentialsImplParameters = [
//        id:           'jenkins-aws-key',
//        description:  'Jenkins AWS IAM key',
//        accessKey:    '01234567890123456789',
//        secretKey:    '01345645657987987987987987987987987987'
//]
//
//// https://github.com/jenkinsci/aws-credentials-plugin/blob/aws-credentials-1.23/src/main/java/com/cloudbees/jenkins/plugins/awscredentials/AWSCredentialsImpl.java
//AWSCredentialsImpl aWSCredentialsImpl = new AWSCredentialsImpl(
//        CredentialsScope.GLOBAL,
//        AWSCredentialsImplParameters.id,
//        AWSCredentialsImplParameters.accessKey,
//        AWSCredentialsImplParameters.secretKey,
//        AWSCredentialsImplParameters.description
//)

// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/SlaveTemplate.java
SlaveTemplate slaveTemplateUsEast1 = new SlaveTemplate(
        SlaveTemplateUsEast1Parameters.ami,
        SlaveTemplateUsEast1Parameters.zone,
        null,
        SlaveTemplateUsEast1Parameters.securityGroups,
        SlaveTemplateUsEast1Parameters.remoteFS,
        InstanceType.fromValue(SlaveTemplateUsEast1Parameters.type),
        SlaveTemplateUsEast1Parameters.ebsOptimized,
        SlaveTemplateUsEast1Parameters.labelString,
        Node.Mode.NORMAL,
        SlaveTemplateUsEast1Parameters.description,
        SlaveTemplateUsEast1Parameters.initScript,
        SlaveTemplateUsEast1Parameters.tmpDir,
        SlaveTemplateUsEast1Parameters.userData,
        SlaveTemplateUsEast1Parameters.numExecutors,
        SlaveTemplateUsEast1Parameters.remoteAdmin,
        new UnixData(null, null, null, "22"),
        SlaveTemplateUsEast1Parameters.jvmopts,
        SlaveTemplateUsEast1Parameters.stopOnTerminate,
        SlaveTemplateUsEast1Parameters.subnetId,
        [SlaveTemplateUsEast1Parameters.tags],
        SlaveTemplateUsEast1Parameters.idleTerminationMinutes,
        SlaveTemplateUsEast1Parameters.usePrivateDnsName,
        SlaveTemplateUsEast1Parameters.instanceCapStr,
        SlaveTemplateUsEast1Parameters.iamInstanceProfile,
        SlaveTemplateUsEast1Parameters.deleteRootOnTermination,
        SlaveTemplateUsEast1Parameters.useEphemeralDevices,
        SlaveTemplateUsEast1Parameters.useDedicatedTenancy,
        SlaveTemplateUsEast1Parameters.launchTimeoutStr,
        SlaveTemplateUsEast1Parameters.associatePublicIp,
        SlaveTemplateUsEast1Parameters.customDeviceMapping,
        SlaveTemplateUsEast1Parameters.connectBySSHProcess,
        SlaveTemplateUsEast1Parameters.connectUsingPublicIp
)

// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/AmazonEC2Cloud.java
AmazonEC2Cloud amazonEC2Cloud = new AmazonEC2Cloud(
        AmazonEC2CloudParameters.cloudName,
        AmazonEC2CloudParameters.useInstanceProfileForCredentials,
        AmazonEC2CloudParameters.credentialsId,
        AmazonEC2CloudParameters.region,
        AmazonEC2CloudParameters.privateKey,
        AmazonEC2CloudParameters.instanceCapStr,
        [slaveTemplateUsEast1],
        "",
        ""
)

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstanceOrNull()

// get credentials domain
//def domain = Domain.global()

// get credentials store
//def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// add credential to store
//store.addCredentials(domain, aWSCredentialsImpl)

// add cloud configuration to Jenkins
jenkins.clouds.removeAll(AmazonEC2Cloud)
jenkins.clouds.add(amazonEC2Cloud)

// save current Jenkins state to disk
jenkins.save()