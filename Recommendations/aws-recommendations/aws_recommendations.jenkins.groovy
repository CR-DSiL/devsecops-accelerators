
node('worker03'){
    properties([
    parameters([
        [$class: 'ChoiceParameter', 
            choiceType: 'PT_SINGLE_SELECT', 
            description: 'Select the Provider Name from the Dropdown List', 
            filterLength: 1, 
            filterable: false, 
            name: 'Provider', 
            randomName: 'choice-parameter-Provider', 
            script: [
                $class: 'GroovyScript', 
                fallbackScript: [
                    classpath: [], 
                    sandbox: true, 
                    script: 
                        'return[\'Could not get Provider\']'
                ], 
                script: [
                    classpath: [], 
                    sandbox: true, 
                    script: 
                        'return["AWS","GCP"]'
                ]
            ]
        ], 
        [$class: 'CascadeChoiceParameter', 
            choiceType: 'PT_SINGLE_SELECT', 
            description: 'Select the Recommendations from the Dropdown List', 
            filterLength: 1, 
            filterable: false, 
            name: 'Recommendations', 
            randomName: 'choice-parameter-Recommendations', 
            referencedParameters: 'Provider', 
            script: [
                $class: 'GroovyScript', 
                fallbackScript: [
                    classpath: [], 
                    sandbox: true, 
                    script: 
                        'return[\'Could not get Recommendations from Env Param\']'
                ], 
                script: [
                    classpath: [], 
                    sandbox: true, 
                    script: 
                        ''' if (Provider.equals("AWS")){
                                return["EC2 RECOMMENDATIONS","EBS RECOMMENDATIONS"]
                            }
                        '''
                ]
            ]
        ]
    ]),
        pipelineTriggers([
            parameterizedCron('''
                TZ=Asia/Calcutta
            #IST (Indian Standard Time)
            #-----------------AWS--------------------------
            #-------EC2 RECOMMENDATIONS----AWS---
            #15 09 * * 1-5 %Provider=AWS;Recommendations=EC2 RECOMMENDATIONS
            #-------EBS RECOMMENDATIONS----AWS---
            #15 09 * * 1-5 %Provider=AWS;Recommendations=EBS RECOMMENDATIONS
            ''')
        ])
    ])

    if(Provider.equals('AWS')){
        if(Recommendations.equals('EC2 RECOMMENDATIONS')){
            stage('Git Clone'){
                git branch: 'main', url: 'git@github.com:Tinkuch/aws_recommendations.git'
                sh 'chmod 777 /tmp/jenkins/workspace/AWS_Recommendations/aws_recommendations'
            }
            stage("EC2 RECOMMENDATIONS"){
                dir ("${env.WORKSPACE}"){
                    sh 'chmod 755 ec2_recommendations.sh'
                    sh './ec2_recommendations.sh' 
                }
            }
        }
        else if(Recommendations.equals('EBS RECOMMENDATIONS')){
            stage('Git Clone'){
                git branch: 'main', url: 'git@github.com:Tinkuch/aws_recommendations.git'
                sh 'chmod 777 /tmp/jenkins/workspace/AWS_Recommendations/aws_recommendations'
            }
            stage("EBS RECOMMENDATIONS"){
                dir ("${env.WORKSPACE}"){
                    sh 'chmod 755 ebs_recommendations.sh'
                    sh './ebs_recommendations.sh'
                }
            }
        }
    }
}