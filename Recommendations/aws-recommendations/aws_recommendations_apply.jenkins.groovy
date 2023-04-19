node('worker03'){
        stage('Git Clone'){
            git branch: 'main', url: 'git@github.com:Tinkuch/aws_recommendations.git'
            sh 'chmod 777 /tmp/jenkins/workspace/AWS_Recommendations/recommendations_apply'
        }
        stage("AWS"){
            dir ("${env.WORKSPACE}"){
                sh 'chmod 755 ec2_recommendations_apply.sh'
                sh './ec2_recommendations_apply.sh'
            }
        }
    }