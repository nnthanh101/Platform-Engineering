import { expect as expectCDK, matchTemplate, MatchStyle } from '@aws-cdk/assert';
import * as cdk from '@aws-cdk/core';
import * as Task1 from '../lib/task1-stack';

test('Empty Stack', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new Task1.Cdk8sStack(app, 'MyTestStack');
    // THEN
    expectCDK(stack).to(matchTemplate({
      "Resources": {}
    }, MatchStyle.EXACT))
});
