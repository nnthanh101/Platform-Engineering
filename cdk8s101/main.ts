import { Construct } from 'constructs';
import { App, Chart, ChartProps, ApiObject } from 'cdk8s';

import * as kplus from 'cdk8s-plus-22';

let redisDone = false;
let postgresDone = false;

const POD_INSTANCES = 1;
const REDIS_POD_INSTANCES = 2;

/**
 * cat help
 * ./deploy.sh
 * kubectl get all
 */
export class MyChart extends Chart {
  constructor(scope: Construct, id: string, props: ChartProps = {}) {
    super(scope, id, props);

    // define resources here

    const APPLABEL        = 'demo-voting-app'
    const REDISPORT       = 6379;
    const REDISIMAGE      = 'redis'
    // const REDISSVCNAME    = 'redis';

    const POSTGRESPORT    = 5432;
    const POSTGRESIMAGE   = 'postgres';
    // const POSTGRESSVCNAME = 'db';

    const VOTINGAPPPORT  = 80;
    const RESULTAPPPORT  = 80;

    const VOTINGAPPIMAGE  = 'kodekloud/examplevotingapp_vote:v1';
    const RESULTAPPIMAGE  = 'kodekloud/examplevotingapp_result:v1';
    const WORKEAPPIMAGE   = 'kodekloud/examplevotingapp_worker:v1';

    /** 1. Redis */
    const rediscontainer = new kplus.Container({
      image: REDISIMAGE,
      port:  REDISPORT
    });

    const redisDeploy = this.createCdk8sDeploymment(this, APPLABEL, "redisDeploy", rediscontainer, REDIS_POD_INSTANCES);

    /* Expose the deployment as a Load Balancer service and make it run */
    redisDeploy.exposeViaService({
      port: REDISPORT, 
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    });

    /** 2. PostgreSQL */
    const postgresContainer = new kplus.Container({
      image: POSTGRESIMAGE,
      port: POSTGRESPORT
    });

    postgresContainer.addEnv('POSTGRES_USER', kplus.EnvValue.fromValue('postgres'));
    /* use a specific key from a secret */
    postgresContainer.addEnv('POSTGRES_PASSWORD', kplus.EnvValue.fromValue('postgres'));
    const postgresdeploy = this.createCdk8sDeploymment(this, APPLABEL, "postgresdeploy", postgresContainer, POD_INSTANCES);

    postgresdeploy.exposeViaService({
      port: POSTGRESPORT,
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    })

    /** 3. VotingApp */
    const votingappcontainer = new kplus.Container({
      image: VOTINGAPPIMAGE,
      port:  VOTINGAPPPORT
    })
    const votingappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "votingappdeploy", votingappcontainer, POD_INSTANCES);
    votingappdeploy.exposeViaService({
      port: VOTINGAPPPORT,
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    });

    /** 4. ResultApp */
    const resultappcontainer = new kplus.Container({
      image: RESULTAPPIMAGE,
      port:  RESULTAPPPORT
    })
    const resultappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "resultappdeploy", resultappcontainer, POD_INSTANCES);
    resultappdeploy.exposeViaService({
      port: RESULTAPPPORT,
      serviceType: kplus.ServiceType.LOAD_BALANCER,
    });

    /** 5. WorkerApp */
    const workappcontainer = new kplus.Container({
      image: WORKEAPPIMAGE,
    })
    // const workerappdeploy = this.createCdk8sDeploymment(this, APPLABEL, "workerappdeploy",workappcontainer, POD_INSTANCES)
    this.createCdk8sDeploymment(this, APPLABEL, "workerappdeploy",workappcontainer, POD_INSTANCES)

  }

  private createCdk8sDeploymment(chart: MyChart,
    label: string,
    deploylabel: string,
    container: kplus.Container,
    replicas: number): kplus.Deployment {

    const deployment = new kplus.Deployment(
      chart,
      deploylabel, {
        replicas: replicas
      })
    deployment.addContainer(container);
    deployment.metadata.addLabel('app', label);

    return deployment;
  }

  public generateObjectName(apiObject: ApiObject) {
    if (typeof apiObject != 'undefined') {
      if (typeof apiObject.metadata != 'undefined') {
        let override = apiObject.metadata.getLabel('overide-name')!
        console.log(override)
      }
    }
    if (typeof apiObject != 'undefined' && apiObject) {
      if (apiObject.kind == 'Service' && !redisDone) {
        redisDone = true;
        return "redis";
      }
      if (apiObject.kind == 'Service' && redisDone && !postgresDone) {
        postgresDone = true;
        return "db";
      }
      else {
        return super.generateObjectName(apiObject);
      }
    }
    return super.generateObjectName(apiObject);
  }

}

const app = new App();
new MyChart(app, 'CDK8s');
app.synth();
