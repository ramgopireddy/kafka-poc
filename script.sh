# enable user workload monitoring at the cluster level

#create PodMonitor resource
oc create -f podmonitor/strimzi-pod-monitor.yaml

#create mentrics cofigmap for kafka
oc create -f kafka-metrics-config.yaml

#create kafka cluster
oc create -f kafka-metrics.yaml 

#Create grafana instance
oc create sa grafana-service-account -n loyalty
 
oc apply -f grafana-crb.yaml -n loyalty

oc create -f grafana/grafana-secret-sa.yaml

oc describe sa/grafana-service-account | grep Tokens:

oc describe secret grafana-service-account-token-4xpgl | grep token:

## add the output token to datasource.yaml

oc create configmap grafana-config --from-file=grafana/datasource.yaml -n loyalty

oc create -f grafana/grafana-deploy.yaml -n loyalty

oc create route edge loyalty-grafana --service=grafana --namespace=loyalty

# Add sso steps here
oc create -f sso/sso.yaml
oc create -f sso-realm.yaml

#create registry
oc create -f registry/registry.yaml