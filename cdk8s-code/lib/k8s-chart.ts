import { Construct } from 'constructs';
import { ApiObject, Chart } from 'cdk8s';
import * as kplus from 'cdk8s-plus';

let redisdone = false;
let postgresdone = false;
/**
 * JAM TASK change number of instances to 2.
 * run the below sequence of steps
 *
 * npm run build
 * cdk synth
 * cdk diff
 * cdk deploy
 *
 * wait for deployment to complete
 *
 * kubectl get all
 *
 * check if there are 2 instances for each POD's - Your result should look similar to below.
 *
 * NAME                                                               READY   STATUS    RESTARTS   AGE
pod/mychart-deployment-89497a89-f99f49f48-zps6c                    1/1     Running   0          45h
pod/mychart-postgresdeploy-deployment-e704ce35-b949696f-68qh8      1/1     Running   0          45h
pod/mychart-postgresdeploy-deployment-e704ce35-b949696f-j855h      1/1     Running   0          55s
pod/mychart-redisdeploy-deployment-fa1ab5c4-79499ccb5d-crn4w       1/1     Running   0          55s
pod/mychart-redisdeploy-deployment-fa1ab5c4-79499ccb5d-mqt8q       1/1     Running   0          45h
pod/mychart-resultappdeploy-deployment-450c514b-79ccf57ffc-89cn5   1/1     Running   0          55s
pod/mychart-resultappdeploy-deployment-450c514b-79ccf57ffc-c45ws   1/1     Running   0          45h
pod/mychart-votingappdeploy-deployment-098ff273-6c947dbc77-n4khr   1/1     Running   0          55s
pod/mychart-votingappdeploy-deployment-098ff273-6c947dbc77-zd6mr   1/1     Running   0          45h
pod/mychart-workerappdeploy-deployment-1620e902-66d86fd549-9p6xv   1/1     Running   0          55s
pod/mychart-workerappdeploy-deployment-1620e902-66d86fd549-c8pnj   1/1     Running   0          45h
*/

const POD_INSTANCES = 1;
const REDIS_POD_INSTANCES = 2;

export class K8sChart extends Chart {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    const APPLABEL = 'demo-voting-app'
    const REDISPORT = 6379;
    const REDISIMAGE = 'redis'
    const REDISSVCNAME = 'redis';

    const POSTGRESPORT = 5432;
    const POSTGRESIMAGE = 'postgres';
    const POSTGRESSVCNAME = 'db';

    const VOTINGAPPIMAGE = 'kodekloud/examplevotingapp_vote:v1';
    const RESULTAPPIMAGE = 'kodekloud/examplevotingapp_result:v1';
    const WORKEAPPIMAGE = 'kodekloud/examplevotingapp_worker:v1';


    //Redis
    const rediscontainer = new kplus.Container({
      image: REDISIMAGE,
      port: REDISPORT
    });

    const redisdeploy = this.createCdk8sDeploymment(this, APPLABEL, "redisdeploy", rediscontainer, REDIS_POD_INSTANCES);

    redisdeploy.expose(REDISPORT, {
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    })

    //Postgres
    const postgrescontainer = new kplus.Container({
      image: POSTGRESIMAGE,
      port: POSTGRESPORT
    });

    postgrescontainer.addEnv('POSTGRES_USER', kplus.EnvValue.fromValue('postgres'));
    // use a specific key from a secret.
    postgrescontainer.addEnv('POSTGRES_PASSWORD', kplus.EnvValue.fromValue('postgres'));
    const postgresdeploy = this.createCdk8sDeploymment(this, APPLABEL, "postgresdeploy", postgrescontainer, POD_INSTANCES);

    postgresdeploy.expose(POSTGRESPORT, {
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    })

    //Votingapp
    const votingappcontainer = new kplus.Container({
      image: VOTINGAPPIMAGE,
      port: 80
    })
    const votingappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "votingappdeploy", votingappcontainer, POD_INSTANCES);
    votingappdeploy.expose(80, {
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    });

    //Resultapp
    const resultappcontainer = new kplus.Container({
      image: RESULTAPPIMAGE,
      port: 80
    })
    const resultappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "resultappdeploy", resultappcontainer, POD_INSTANCES);
    resultappdeploy.expose(80, {
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    });

    //workerapp
    const workappcontainer = new kplus.Container({
      image: WORKEAPPIMAGE,
    })
    const workerappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "workerappdeploy",workappcontainer, POD_INSTANCES)

  }

  private createCdk8sDeploymment(chart: K8sChart,
    label: string,
    deploylabel: string,
    container: kplus.Container,
    replicas: number) : kplus.Deployment {

    const deployment = new kplus.Deployment(
      chart,
      deploylabel, {
        replicas: replicas
        }
      )
    deployment.addContainer(container);
    deployment.metadata.addLabel('app',label);

    return deployment;
  }

  public generateObjectName(apiObject: ApiObject){
    if(typeof apiObject!='undefined'){
      if(typeof apiObject.metadata!='undefined'){
        let override = apiObject.metadata.getLabel('overide-name')!
        console.log(override)
      }
    }
    if(typeof apiObject!='undefined' && apiObject){
      if(apiObject.kind == 'Service' && !redisdone){
        redisdone = true;
        return "redis";
      }
      if(apiObject.kind == 'Service' && redisdone && !postgresdone){
        postgresdone = true;
        return "db";
      }
      else{
        return super.generateObjectName(apiObject);
      }
    }
    return super.generateObjectName(apiObject);
  }
}