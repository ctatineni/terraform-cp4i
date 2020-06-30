export KUBECONFIG=${HOME}/installer/auth/kubeconfig
KEY=$1
oc new-project cp4i
oc create secret docker-registry ibm-entitlement-key --docker-server=cp.icr.io --docker-username=cp --docker-password=$KEY --docker-email=chandhubabu.thathineni@ibm.com -n cp4i

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ibm-cp4i-operatorgroup
  namespace: cp4i
spec:
  targetNamespaces:
  - cp4i
EOF

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
  name: ibm-common-service-operator-stable-opencloud-operators-openshift-marketplace
  namespace: cp4i
spec:
  channel: stable-v1
  config:
    resources: {}
  installPlanApproval: Automatic
  name: ibm-common-service-operator
  source: opencloud-operators
  sourceNamespace: openshift-marketplace
EOF



# Platform Navigator

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-integration-platform-navigator-subscription
  namespace: cp4i
spec:
  channel: v4.0
  name: ibm-integration-platform-navigator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

sleep 2m

cat <<EOF | oc create -f -
apiVersion: integration.ibm.com/v1beta1
kind: PlatformNavigator
metadata:
    name: cp4i-navigator
    namespace: cp4i
spec:
    license:
        accept: true
    mqDashboard: true
    replicas: 3
    version: 2020.2.1
EOF

# Operations Dashboard

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-integration-operations-dashboard
  namespace: cp4i
spec:
  channel: v1.0
  installPlanApproval: Automatic
  name: ibm-integration-operations-dashboard
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
  startingCSV: ibm-integration-operations-dashboard.v1.0.0
EOF

cat <<EOF | oc create -f -
apiVersion: integration.ibm.com/v1beta1
kind: OperationsDashboard
metadata:
  labels:
    app.kubernetes.io/instance: ibm-integration-operations-dashboard
    app.kubernetes.io/managed-by: ibm-integration-operations-dashboard
    app.kubernetes.io/name: ibm-integration-operations-dashboard
  name: tracing
  namespace: cp4i
spec:
  global:
    images:
      configDb: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-config-db@sha256:ed92ca5a4c4f1afd014148db0f4a75944c2538f78bc18ec382f4c96adc153433
      housekeeping: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-housekeeping@sha256:f923a8e9b61fa76cdfa413f0bd96890123735ff0d32508fe20e371097e8e4cd8
      installAssist: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-install-assist@sha256:900c61098dce803b0be707318c77cb9a40df00c359c936b49c4ff162f2aa0cfb
      legacyUi: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-legacy-ui@sha256:52396f272a6573c51338712fe8b8c0bc72fdf11db37308ef86894fd5b7401625
      oidcConfigurator: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-oidc-configurator@sha256:b5ecb85c10f8716957bc0e3979f36ebc1e1fd800a270eb0065f310f0f9100b6b
      pullPolicy: IfNotPresent
      registrationEndpoint: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-registration-endpoint@sha256:19947e936e00d5eab44e6ece88a6fa4cadbf846df8db1a4748fcf713ea9758e6
      registrationProcessor: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-registration-processor@sha256:c8f5b57d26e411aaa46a26377d2e8e6c95ff862c73e74c935bfa0bb70c02adb6
      reports: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-reports@sha256:e2bda58b1b820fea1b994c279a5fe33de36dd6ffb24eca04cea2f8b4693b968b
      store: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-store@sha256:30492b1c025db622074355f38d713d0609db79000597f9e3fcd92cde142e8048
      storeRetention: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-store-retention@sha256:a82da833b902f9db33ed94fb2b8558d202119a061810d0a791ad6b3bfcab1d5c
      uiManager: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-ui-manager@sha256:c21d756a2ea6a06990bd464cec5674ef1fb9cdf07b1f4a50d1a6abf3784a84df
      uiProxy: >-
        cp.icr.io/cp/icp4i/od/icp4i-od-ui-proxy@sha256:72e00c40d51e6c27a854475985606f9de20c47738a2ab2c987e3bfdbcc2c57a0
    replicas:
      manager: 1
      store: 1
    resources:
      configDb:
        limits:
          cpu: '2'
          memory: 2048Mi
        requests:
          cpu: '0.5'
          memory: 1024Mi
      housekeeping:
        limits:
          cpu: '1'
          memory: 2048Mi
        requests:
          cpu: '0.5'
          memory: 768Mi
      initializationJobs:
        limits:
          cpu: '0.5'
          memory: 512Mi
        requests:
          cpu: '0.25'
          memory: 256Mi
      legacyUi:
        limits:
          cpu: '1'
          memory: 2048Mi
        requests:
          cpu: '0.25'
          memory: 1024Mi
      registrationEndpoint:
        limits:
          cpu: '0.5'
          memory: 1024Mi
        requests:
          cpu: '0.1'
          memory: 256Mi
      registrationProcessor:
        limits:
          cpu: '0.5'
          memory: 1024Mi
        requests:
          cpu: '0.1'
          memory: 384Mi
      reports:
        limits:
          cpu: '8'
          memory: 4096Mi
        requests:
          cpu: '0.5'
          memory: 1024Mi
      store:
        heapSize: 8192M
        limits:
          cpu: '4'
          memory: 10240Mi
        requests:
          cpu: '2'
          memory: 9216Mi
      storeRetention:
        limits:
          cpu: '2'
          memory: 2048Mi
        requests:
          cpu: '0.8'
          memory: 768Mi
      uiManager:
        limits:
          cpu: '4'
          memory: 4096Mi
        requests:
          cpu: '1'
          memory: 1024Mi
      uiProxy:
        limits:
          cpu: '4'
          memory: 1024Mi
        requests:
          cpu: '0.2'
          memory: 512Mi
    storage:
      configDb:
        type: persistent-claim
        volumeClaimTemplate:
          spec:
            resources:
              requests:
                storage: 2Gi
            storageClassName: rook-ceph-block
      store:
        type: persistent-claim
        volumeClaimTemplate:
          spec:
            resources:
              requests:
                storage: 10Gi
            storageClassName: rook-ceph-block
  license:
    accept: true
  version: 2020.2.1-0
EOF

# APP Connect

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-appconnect
  namespace: cp4i
spec:
  channel: v1.0
  installPlanApproval: Automatic
  name: ibm-appconnect
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
  startingCSV: ibm-appconnect.v1.0.1
EOF

cat <<EOF | oc create -f -
apiVersion: appconnect.ibm.com/v1beta1
kind: Dashboard
metadata:
  name: db-quickstart
  namespace: cp4i
spec:
  license:
    accept: true
    license: L-AMYG-BQ2E4U
    use: CloudPakForIntegrationNonProduction
  replicas: 1
  storage:
    class: 'csi-cephfs'
    type: persistent-claim
  version: 11.0.0
EOF

cat <<EOF | oc create -f -
apiVersion: appconnect.ibm.com/v1beta1
kind: SwitchServer
metadata:
  name: default
  namespace: cp4i
spec:
  license:
    accept: true
    license: L-AMYG-BQ2FUA
    use: AppConnectEnterpriseNonProduction
  useCommonServices: true
  version: 11.0.0
EOF

cat <<EOF | oc create -f -
apiVersion: appconnect.ibm.com/v1beta1
kind: DesignerAuthoring
metadata:
  name: des-mapast
  namespace: cp4i
spec:
  couchdb:
    storage:
      class: 'rook-ceph-block'
      size: 10Gi
      type: persistent-claim
  designerFlowsOperationMode: all
  designerMappingAssist:
    enabled: true
  license:
    accept: true
    license: L-AMYG-BQ2E4U
    use: AppConnectEnterpriseProduction
  useCommonServices: true
  version: 11.0.0
  appConnectInstanceID: abcde123
  appConnectURL: 'https://firefly-api-prod.appconnect.ibmcloud.com'
  ibmCloudAPIKey: 123456asdfg789hjklluiop
  replicas: 3
  switchServer:
    name: default
EOF

# IBM MQ

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: ClusterServiceVersion
metadata:
  annotations:
    certified: 'false'
    olm.targetNamespaces: cp4i
    alm-examples-metadata: |-
      {
        "quickstart-cp4i": {
          "name": "Quick start",
          "description": "MQ V9.1.5 queue manager for Quick start. This uses ephemeral storage, and MQ security is disabled.",
          "resources": {
            "cpu": "1",
            "memory": "1 GB",
            "vpc": "0.25"
          }
        }
      }
    repository: N/A
    support: IBM
    alm-examples: |-
      [
        {
          "apiVersion": "mq.ibm.com/v1beta1",
          "kind": "QueueManager",
          "metadata": {
            "name": "quickstart-cp4i"
          },
          "spec": {
            "license": {
              "accept": false,
              "license": "L-RJON-BN7PN3",
              "use": "NonProduction"
            },
            "queueManager": {
              "name": "QUICKSTART",
              "storage": {
                "queueManager": {
                  "type": "ephemeral"
                }
              }
            },
            "template": {
              "pod": {
                "containers": [
                  {
                    "env": [
                      {
                        "name": "MQSNOAUT",
                        "value": "yes"
                      }
                    ],
                    "name": "qmgr"
                  }
                ]
              }
            },
            "version": "9.1.5.0-r2",
            "web": {
              "enabled": true
            }
          }
        }
      ]
    capabilities: Basic Install
    olm.operatorNamespace: cp4i
    containerImage: N/A
    createdAt: 'Thu 18 Jun 2020 18:00:24 BST'
    categories: Streaming & Messaging
    description: IBM MQ is an operator to manage the life cycle of IBM MQ queue managers
    olm.operatorGroup: ibm-integration-platform-navigator-operatorgroup
  name: ibm-mq.v1.0.0
  namespace: cp4i
  labels:
    olm.api.104d090ec6b99a16: provided
    olm.api.d5bce463307a1f31: required
spec:
  customresourcedefinitions:
    owned:
      - description: >-
          A QueueManager is an IBM MQ server which provides queuing and
          publish/subscribe services to applications
        displayName: Queue Manager
        kind: QueueManager
        name: queuemanagers.mq.ibm.com
        specDescriptors:
          - displayName: Affinity
            path: affinity
          - description: Node affinity scheduling rules for the Queue Manager's pod
            displayName: Node affinity
            path: affinity.nodeAffinity
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Affinity'
              - 'urn:alm:descriptor:com.tectonic.ui:nodeAffinity'
          - description: >-
              Pod affinity scheduling rules (e.g. co-locate this pod in the same
              node, zone, etc. as some other pod(s))
            displayName: Pod affinity
            path: affinity.podAffinity
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Affinity'
              - 'urn:alm:descriptor:com.tectonic.ui:podAffinity'
          - description: >-
              Pod anti-affinity scheduling rules (e.g. avoid putting this pod in
              the same node, zone, etc. as some other pod(s))
            displayName: Pod anti-affinity
            path: affinity.podAntiAffinity
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Affinity'
              - 'urn:alm:descriptor:com.tectonic.ui:podAntiAffinity'
          - description: >-
              An optional list of references to secrets in the same namespace to
              use for pulling any of the images used by this QueueManager. If
              specified, these secrets will be passed to individual puller
              implementations for them to use. For example, in the case of
              docker, only DockerConfig type secrets are honored. For more
              information, see
              https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod
            displayName: Image Pull Secrets
            path: imagePullSecrets
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Image Pull Secrets'
              - 'urn:alm:descriptor:io.kubernetes:Secret'
          - description: >-
              Settings that control your acceptance of the license, and which
              license metrics to use
            displayName: License
            path: license
          - description: >-
              Whether or not you accept the license associated with this
              software (required)
            displayName: License acceptance
            path: license.accept
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:License'
          - description: >-
              The identifier of the license you are accepting.  This must be the
              correct license identifier for the version of MQ you are using. 
              See http://ibm.biz/BdqvCF for valid values.
            displayName: License
            path: license.license
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:License'
              - 'urn:alm:descriptor:com.tectonic.ui:select:L-APIG-BJAKBF'
              - 'urn:alm:descriptor:com.tectonic.ui:select:L-APIG-BM7GDH'
              - 'urn:alm:descriptor:com.tectonic.ui:select:L-RJON-BN7PN3'
              - 'urn:alm:descriptor:com.tectonic.ui:select:L-RJON-BPHL2Y'
          - description: >-
              Setting that specifies which license metric to use. For example,
              "ProcessorValueUnit", "VirtualProcessorCore" or
              "ManagedVirtualServer".
            displayName: License metric
            path: license.metric
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:License'
              - 'urn:alm:descriptor:com.tectonic.ui:select:ManagedVirtualServer'
              - 'urn:alm:descriptor:com.tectonic.ui:select:ProcessorValueUnit'
              - 'urn:alm:descriptor:com.tectonic.ui:select:VirtualProcessorCore'
          - description: >-
              Setting that controls how the software will to be used, where the
              license supports multiple uses. See http://ibm.biz/BdqvCF for
              valid values.
            displayName: License use
            path: license.use
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:License'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - displayName: PKI
            path: pki
          - description: Private keys to add to the Queue Manager's key repository
            displayName: Keys
            path: pki.keys
          - description: >-
              Name is used as the label for the key or certificate.  Must be a
              lowercase alphanumeric string.
            displayName: Name
            path: 'pki.keys[0].name'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:arrayFieldGroup:Public Key
                Infrastructure
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - description: Supply a key using a Kubernetes Secret
            displayName: Secret
            path: 'pki.keys[0].secret'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:arrayFieldGroup:Public Key
                Infrastructure
              - 'urn:alm:descriptor:io.kubernetes:Secret'
          - description: The name of the Kubernetes secret
            displayName: Secret name
            path: 'pki.keys[0].secret.secretName'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:Secret'
          - description: Certificates to add to the Queue Manager's key repository
            displayName: Trust
            path: pki.trust
          - description: >-
              Name is used as the label for the key or certificate.  Must be a
              lowercase alphanumeric string.
            displayName: Name
            path: 'pki.trust[0].name'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:arrayFieldGroup:Public Key
                Infrastructure
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - description: Supply a key using a Kubernetes Secret
            displayName: Secret
            path: 'pki.trust[0].secret'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:arrayFieldGroup:Public Key
                Infrastructure
              - 'urn:alm:descriptor:io.kubernetes:Secret'
          - description: The name of the Kubernetes secret
            displayName: Secret name
            path: 'pki.trust[0].secret.secretName'
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:Secret'
          - displayName: Queue Manager
            path: queueManager
          - description: >-
              Availability settings for the Queue Manager, such as whether or
              not to use an active-standby pair
            displayName: Availability
            path: queueManager.availability
          - description: >-
              The type of availability to use. Use "SingleInstance" for a single
              Pod, which will be restarted automatically (in some cases) by
              Kubernetes. Use "MultiInstance" for a pair of Pods, one of which
              is the "active" Queue Manager, and the other of which is a
              standby. See
              https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_latest/com.ibm.mq.ctr.doc/ha_for_ctr.htm
              for more details.
            displayName: Type of availability
            path: queueManager.availability.type
            x-descriptors:
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
              - 'urn:alm:descriptor:com.tectonic.ui:select:MultiInstance'
              - 'urn:alm:descriptor:com.tectonic.ui:select:SingleInstance'
          - description: >-
              Whether or not to log debug messages from the container-specific
              code, to the container log
            displayName: Debug
            path: queueManager.debug
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: The container image that will be used
            displayName: Container Image
            path: queueManager.image
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:Image'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              Setting that controls when the kubelet attempts to pull the
              specified image
            displayName: Image pull policy
            path: queueManager.imagePullPolicy
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:imagePullPolicy'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: Settings that control the liveness probe
            displayName: Liveness Probe
            path: queueManager.livenessProbe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: queueManager.livenessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Liveness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: queueManager.livenessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Liveness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: How often (in seconds) to perform the probe
            displayName: Probe Period
            path: queueManager.livenessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Liveness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: queueManager.livenessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Liveness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: queueManager.livenessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Liveness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Which log format to use for this container.  Use "JSON" for
              JSON-formatted logs from the container.  Use "Basic" for
              text-formatted messages.
            displayName: Log format
            path: queueManager.logFormat
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
              - 'urn:alm:descriptor:com.tectonic.ui:select:Basic'
              - 'urn:alm:descriptor:com.tectonic.ui:select:JSON'
          - description: Settings for Prometheus-style metrics
            displayName: Metrics
            path: queueManager.metrics
          - description: Whether or not to enable a Prometheus-compatible metrics endpoint
            displayName: Enabled
            path: queueManager.metrics.enabled
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              Name of the underlying MQ Queue Manager, if different from
              metadata.name. Use this field if you want a Queue Manager name
              which does not conform to the Kubernetes rules for names (for
              example, a name which includes captial letters).
            displayName: Name
            path: queueManager.name
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - description: Settings that control the readiness probe
            displayName: Readiness Probe
            path: queueManager.readinessProbe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: queueManager.readinessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Readiness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: queueManager.readinessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Readiness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: How often (in seconds) to perform the probe
            displayName: Probe Period
            path: queueManager.readinessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Readiness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: queueManager.readinessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Readiness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: queueManager.readinessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Readiness Probe
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: Settings that control resource requirements
            displayName: Resources
            path: queueManager.resources
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
              - 'urn:alm:descriptor:com.tectonic.ui:resourceRequirements'
          - description: >-
              Storage settings to control the Queue Manager's use of Persistent
              Volumes and Storage Classes
            displayName: Storage
            path: queueManager.storage
          - description: >-
              PersistentVolume details for MQ persisted data, including
              configuration, queues and messages. Required when using
              multi-instance Queue Manager.
            displayName: Persisted Data
            path: queueManager.storage.persistedData
          - description: >-
              Storage class to use for this volume. Only valid if "type" is
              "persistent-claim".
            displayName: Class
            path: queueManager.storage.persistedData.class
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:StorageClass'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Persisted Data
                Storage
          - description: >-
              Whether or not this volume should be enabled as a separate volume,
              or be placed on the default "queueManager" volume
            displayName: Enabled
            path: queueManager.storage.persistedData.enabled
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Persisted Data
                Storage
          - description: >-
              Size of the PersistentVolume to pass to Kubernetes. Only valid if
              "type" is "persistent-claim".
            displayName: Size
            path: queueManager.storage.persistedData.size
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:podCount'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Persisted Data
                Storage
          - description: >-
              Size limit when using an "ephemeral" volume.  Files are still
              written to a temporary directory, so you can use this option to
              limit the size. Only valid if `type` is "ephemeral".
            displayName: Size Limit
            path: queueManager.storage.persistedData.sizeLimit
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Persisted Data
                Storage
          - description: >-
              Type of volume to use. Choose `ephemeral` to create a
              non-persistent "emptyDir" volume, or `persistent-claim` to use a
              persistent volume.
            displayName: Type of volume
            path: queueManager.storage.persistedData.type
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:select:ephemeral'
              - 'urn:alm:descriptor:com.tectonic.ui:select:persistent-claim'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Persisted Data
                Storage
          - description: >-
              Default PersistentVolume for any data normally under `/var/mqm`.
              Will contain all persisted data and recovery logs, if no other
              volumes are specified.
            displayName: Queue Manager
            path: queueManager.storage.queueManager
          - description: >-
              Storage class to use for this volume. Only valid if "type" is
              "persistent-claim".
            displayName: Class
            path: queueManager.storage.queueManager.class
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:StorageClass'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              Size of the PersistentVolume to pass to Kubernetes. Only valid if
              "type" is "persistent-claim".
            displayName: Size
            path: queueManager.storage.queueManager.size
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:podCount'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              Size limit when using an "ephemeral" volume.  Files are still
              written to a temporary directory, so you can use this option to
              limit the size. Only valid if `type` is "ephemeral".
            displayName: Size Limit
            path: queueManager.storage.queueManager.sizeLimit
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              Type of volume to use. Choose `ephemeral` to create a
              non-persistent "emptyDir" volume, or `persistent-claim` to use a
              persistent volume.
            displayName: Type of volume
            path: queueManager.storage.queueManager.type
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:select:ephemeral'
              - 'urn:alm:descriptor:com.tectonic.ui:select:persistent-claim'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Queue Manager
                Config
          - description: >-
              PersistentVolume details for MQ recovery logs. Required when using
              multi-instance Queue Manager.
            displayName: Recovery Logs
            path: queueManager.storage.recoveryLogs
          - description: >-
              Storage class to use for this volume. Only valid if "type" is
              "persistent-claim".
            displayName: Class
            path: queueManager.storage.recoveryLogs.class
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:StorageClass'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Recovery Logs
                Storage
          - description: >-
              Whether or not this volume should be enabled as a separate volume,
              or be placed on the default "queueManager" volume
            displayName: Enabled
            path: queueManager.storage.recoveryLogs.enabled
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Recovery Logs
                Storage
          - description: >-
              Size of the PersistentVolume to pass to Kubernetes. Only valid if
              "type" is "persistent-claim".
            displayName: Size
            path: queueManager.storage.recoveryLogs.size
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:podCount'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Recovery Logs
                Storage
          - description: >-
              Size limit when using an "ephemeral" volume.  Files are still
              written to a temporary directory, so you can use this option to
              limit the size. Only valid if `type` is "ephemeral".
            displayName: Size Limit
            path: queueManager.storage.recoveryLogs.sizeLimit
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Recovery Logs
                Storage
          - description: >-
              Type of volume to use. Choose `ephemeral` to create a
              non-persistent "emptyDir" volume, or `persistent-claim` to use a
              persistent volume.
            displayName: Type of volume
            path: queueManager.storage.recoveryLogs.type
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:select:ephemeral'
              - 'urn:alm:descriptor:com.tectonic.ui:select:persistent-claim'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Recovery Logs
                Storage
          - displayName: Security Context
            path: securityContext
          - description: >-
              A special supplemental group that applies to all containers in a
              pod. Some volume types allow the Kubelet to change the ownership
              of that volume to be owned by the pod: 1. The owning GID will be
              the FSGroup 2. The setgid bit is set (new files created in the
              volume will be owned by FSGroup) 3. The permission bits are OR'd
              with rw-rw---- If unset, the Kubelet will not modify the ownership
              and permissions of any volume.
            displayName: FSGroup
            path: securityContext.fsGroup
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Security Context'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - description: >-
              This affects the securityContext used by the container which
              initializes the PersistentVolume. Set this to "true" if you are
              using a storage provider which requires you to be the root user to
              access newly provisioned volumes. Setting this to "true" affects
              which Security Context Constraints (SCC) object you can use, and
              the Queue Manager may fail to start if you are not authorized to
              use an SCC which allows the root user. For more information, see
              https://docs.openshift.com/container-platform/latest/authentication/managing-security-context-constraints.html
            displayName: Init Volume As Root
            path: securityContext.initVolumeAsRoot
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Security Context'
          - description: >-
              A list of groups applied to the first process run in each
              container, in addition to the container's primary GID. If
              unspecified, no groups will be added to any container.
            displayName: Supplemental Groups
            path: securityContext.supplementalGroups
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Security Context'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - displayName: Template
            path: template
          - description: >-
              Overrides for the template used for the Pod. See
              https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#podspec-v1-core
            displayName: Template overrides
            path: template.pod
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
          - description: >-
              Optional duration in seconds the Pod needs to terminate
              gracefully. Value must be non-negative integer. The value zero
              indicates delete immediately. The target time in which ending the
              queue manager is attempted, escalating the phases of application
              disconnection. Essential queue manager maintenance tasks are
              interrupted if necessary.
            displayName: Termination Grace Period Seconds
            path: terminationGracePeriodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Termination Grace
                Period Seconds
              - 'urn:alm:descriptor:com.tectonic.ui:number'
          - description: >-
              Settings for tracing integration with the Cloud Pak for
              Integration Operations Dashboard
            displayName: Open Tracing
            path: tracing
          - description: >-
              In Cloud Pak for Integration only, you can configure settings for
              the optional Tracing Agent
            displayName: Tracing Agent
            path: tracing.agent
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldDependency:tracing.enabled:true
          - description: The container image that will be used
            displayName: Tracing Agent Container Image
            path: tracing.agent.image
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:Image'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
          - description: >-
              Setting that controls when the kubelet attempts to pull the
              specified image
            displayName: Tracing Agent Image Pull Policy
            path: tracing.agent.imagePullPolicy
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:imagePullPolicy'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
          - description: Settings that control the liveness probe
            displayName: Liveness Probe
            path: tracing.agent.livenessProbe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: tracing.agent.livenessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Liveness Probe
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: tracing.agent.livenessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Liveness Probe
          - description: How often (in seconds) to perform the probe
            displayName: Period Seconds
            path: tracing.agent.livenessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Liveness Probe
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: tracing.agent.livenessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Liveness Probe
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: tracing.agent.livenessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Liveness Probe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: tracing.agent.readinessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Readiness Probe
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: tracing.agent.readinessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Readiness Probe
          - description: How often (in seconds) to perform the probe
            displayName: Period Seconds
            path: tracing.agent.readinessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Readiness Probe
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: tracing.agent.readinessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Readiness Probe
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: tracing.agent.readinessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Agent
                Readiness Probe
          - description: >-
              In Cloud Pak for Integration only, you can configure settings for
              the optional Tracing Collector
            displayName: Tracing Collector
            path: tracing.collector
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldDependency:tracing.enabled:true
          - description: The container image that will be used
            displayName: Tracing Collector Container Image
            path: tracing.collector.image
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:io.kubernetes:Image'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
          - description: >-
              Setting that controls when the kubelet attempts to pull the
              specified image
            displayName: Tracing Collector Image Pull Policy
            path: tracing.collector.imagePullPolicy
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:imagePullPolicy'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
          - description: Settings that control the liveness probe
            displayName: Liveness Probe
            path: tracing.collector.livenessProbe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: tracing.collector.livenessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Liveness Probe
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: tracing.collector.livenessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Liveness Probe
          - description: How often (in seconds) to perform the probe
            displayName: Period Seconds
            path: tracing.collector.livenessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Liveness Probe
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: tracing.collector.livenessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Liveness Probe
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: tracing.collector.livenessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Liveness Probe
          - description: >-
              Minimum consecutive failures for the probe to be considered failed
              after having succeeded
            displayName: Failure Threshold
            path: tracing.collector.readinessProbe.failureThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Readiness Probe
          - description: >-
              Number of seconds after the container has started before liveness
              probes are initiated. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Initial Delay Seconds
            path: tracing.collector.readinessProbe.initialDelaySeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Readiness Probe
          - description: How often (in seconds) to perform the probe
            displayName: Period Seconds
            path: tracing.collector.readinessProbe.periodSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Readiness Probe
          - description: >-
              Minimum consecutive successes for the probe to be considered
              successful after having failed
            displayName: Success Threshold
            path: tracing.collector.readinessProbe.successThreshold
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Readiness Probe
          - description: >-
              Number of seconds after which the probe times out. More info:
              https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            displayName: Timeout Seconds
            path: tracing.collector.readinessProbe.timeoutSeconds
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:advanced'
              - 'urn:alm:descriptor:com.tectonic.ui:number'
              - >-
                urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing Collector
                Readiness Probe
          - description: >-
              Whether or not to enable integration with the Cloud Pak for
              Integration Operations Dashboard, via tracing
            displayName: Enable Tracing
            path: tracing.enabled
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
          - description: >-
              Namespace where the Cloud Pak for Integration Operations Dashboard
              is installed
            displayName: Tracing Namespace
            path: tracing.namespace
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Tracing'
              - 'urn:alm:descriptor:io.kubernetes:Namespace'
          - description: >-
              Setting that controls the version of MQ that will be used
              (required). For example: "9.1.5.0-r2" would specify MQ version
              9.1.5.0, using the second revision of the container image.
              Container-specific fixes are often applied in revisions, such as
              fixes to the base image.
            displayName: Version
            path: version
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Version'
              - 'urn:alm:descriptor:com.tectonic.ui:text'
          - description: Settings for the MQ web server
            displayName: Web
            path: web
          - description: Whether or not to enable the web server
            displayName: Enable Web Server
            path: web.enabled
            x-descriptors:
              - 'urn:alm:descriptor:com.tectonic.ui:booleanSwitch'
              - 'urn:alm:descriptor:com.tectonic.ui:fieldGroup:Web Server'
        statusDescriptors:
          - description: URL for the Admin UI
            displayName: Admin UI
            path: adminUiUrl
            x-descriptors:
              - 'urn:alm:descriptor:org.w3:link'
          - description: Phase of the Queue Manager's state
            displayName: Phase
            path: phase
            x-descriptors:
              - 'urn:alm:descriptor:io.kubernetes.phase'
        version: v1beta1
    required:
      - description: CommonService is the Schema for the common services API
        displayName: CommonService
        kind: CommonService
        name: commonservices.operator.ibm.com
        version: v3
  apiservicedefinitions: {}
  keywords:
    - mq
    - queue
    - messaging
    - publish
    - subscribe
    - integration
    - cloud pak
    - cloud pak for integration
    - cp4i
  displayName: IBM MQ
  provider:
    name: IBM
  maturity: stable
  installModes:
    - supported: true
      type: OwnNamespace
    - supported: true
      type: SingleNamespace
    - supported: false
      type: MultiNamespace
    - supported: true
      type: AllNamespaces
  version: 1.0.0
  icon:
    - base64data: >-
        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
      mediatype: image/png
  links:
    - name: IBM MQ in containers
      url: >-
        https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_9.1.0/com.ibm.mq.mcpak.doc/mcpak.htm
  install:
    spec:
      clusterPermissions:
        - rules:
            - apiGroups:
                - admissionregistration.k8s.io
              resources:
                - validatingwebhookconfigurations
              verbs:
                - create
                - get
          serviceAccountName: ibm-mq
      deployments:
        - name: ibm-mq
          spec:
            replicas: 1
            selector:
              matchLabels:
                app.kubernetes.io/component: integration
                app.kubernetes.io/managed-by: olm
                app.kubernetes.io/name: ibm-mq
                name: ibm-mq
            strategy: {}
            template:
              metadata:
                annotations:
                  productID: 208423bb063c43288328b1d788745b0c
                  productMetric: FREE
                  productName: IBM MQ Operator
                  productVersion: 1.0.0
                creationTimestamp: null
                labels:
                  app.kubernetes.io/component: integration
                  app.kubernetes.io/managed-by: olm
                  app.kubernetes.io/name: ibm-mq
                  name: ibm-mq
              spec:
                affinity:
                  nodeAffinity:
                    requiredDuringSchedulingIgnoredDuringExecution:
                      nodeSelectorTerms:
                        - matchExpressions:
                            - key: kubernetes.io/arch
                              operator: In
                              values:
                                - amd64
                            - key: kubernetes.io/os
                              operator: In
                              values:
                                - linux
                containers:
                  - resources:
                      limits:
                        cpu: '1'
                        memory: 1Gi
                      requests:
                        cpu: '1'
                        memory: 1Gi
                    readinessProbe:
                      failureThreshold: 3
                      httpGet:
                        path: /readyz
                        port: 6789
                      initialDelaySeconds: 10
                      periodSeconds: 5
                      timeoutSeconds: 3
                    name: ibm-mq
                    command:
                      - ibm-mq
                    livenessProbe:
                      failureThreshold: 1
                      httpGet:
                        path: /healthz
                        port: 6789
                      initialDelaySeconds: 90
                      periodSeconds: 10
                      timeoutSeconds: 5
                    env:
                      - name: WATCH_NAMESPACE
                        valueFrom:
                          fieldRef:
                            fieldPath: 'metadata.annotations[''olm.targetNamespaces'']'
                      - name: POD_NAME
                        valueFrom:
                          fieldRef:
                            fieldPath: metadata.name
                      - name: OPERATOR_NAME
                        value: ibm-mq
                      - name: IMAGE_MQ_ADVANCED_9150r2
                        value: >-
                          cp.icr.io/cp/ibm-mqadvanced-server@sha256:8dee84b6f41a5da4b0a3e10e4e7e29832f571c30fc4d85bbbe5ef5f554a7d7af
                      - name: IMAGE_MQ_ADVANCED_INTEGRATION_9150r2
                        value: >-
                          cp.icr.io/cp/ibm-mqadvanced-server-integration@sha256:615a3730ab42a57537fe65a617a13eac59e9c0858d5cfc9abeb8555a6b534225
                      - name: IMAGE_MQ_ADVANCED_DEV_9150r2
                        value: >-
                          docker.io/ibmcom/mq@sha256:9bcee09b99b596610e7d660d597b76d9c395ed9bb6bdb970b8975ac6a3c0217e
                      - name: IMAGE_TRACING_AGENT
                        value: >-
                          cp.icr.io/cp/icp4i/od/icp4i-od-agent@sha256:a64a66f6ac24eaf4d4b5fdb2abe3a2b6361b735fa9d3699a594c869fd8366a77
                      - name: IMAGE_TRACING_COLLECTOR
                        value: >-
                          cp.icr.io/cp/icp4i/od/icp4i-od-collector@sha256:4c9578e17f116105d29b32783c825082560e194ec4d372e00666d7be499abc40
                    securityContext:
                      allowPrivilegeEscalation: false
                      capabilities:
                        drop:
                          - ALL
                      privileged: false
                      readOnlyRootFilesystem: false
                      runAsNonRoot: true
                    imagePullPolicy: Always
                    image: >-
                      docker.io/ibmcom/ibm-mq-operator@sha256:c921dd79c2b53251e72bc53586ca3aff88b9a3ed9484bc1ef3c064b6be095034
                initContainers:
                  - command:
                      - ibm-mq
                      - '--init'
                    env:
                      - name: NAMESPACE
                        valueFrom:
                          fieldRef:
                            fieldPath: metadata.namespace
                      - name: POD_NAME
                        valueFrom:
                          fieldRef:
                            fieldPath: metadata.name
                      - name: OPERATOR_NAME
                        value: ibm-mq
                    image: >-
                      docker.io/ibmcom/ibm-mq-operator@sha256:c921dd79c2b53251e72bc53586ca3aff88b9a3ed9484bc1ef3c064b6be095034
                    imagePullPolicy: Always
                    name: ibm-mq-init
                    resources:
                      limits:
                        cpu: '1'
                        memory: 1Gi
                      requests:
                        cpu: '1'
                        memory: 1Gi
                    securityContext:
                      allowPrivilegeEscalation: false
                      capabilities:
                        drop:
                          - ALL
                      privileged: false
                      readOnlyRootFilesystem: false
                      runAsNonRoot: true
                serviceAccountName: ibm-mq
      permissions:
        - rules:
            - apiGroups:
                - ''
              resources:
                - pods
                - services
                - services/finalizers
                - endpoints
                - persistentvolumeclaims
                - events
                - configmaps
                - secrets
                - serviceaccounts
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - apps
              resources:
                - deployments
                - daemonsets
                - replicasets
                - statefulsets
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - batch
              resources:
                - jobs
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - monitoring.coreos.com
              resources:
                - servicemonitors
              verbs:
                - get
                - create
            - apiGroups:
                - apps
              resourceNames:
                - ibm-mq
              resources:
                - deployments/finalizers
              verbs:
                - update
            - apiGroups:
                - ''
              resources:
                - pods
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - apps
              resources:
                - replicasets
                - deployments
              verbs:
                - get
            - apiGroups:
                - mq.ibm.com
              resources:
                - queuemanagers
                - queuemanagers/finalizers
                - queuemanagers/status
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - route.openshift.io
              resources:
                - routes
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - cp4i.ibm.com
              resources:
                - cp4iservicesbindings
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - oidc.security.ibm.com
              resources:
                - clients
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - operator.ibm.com
              resources:
                - operandrequests
              verbs:
                - create
                - delete
                - get
                - list
                - patch
                - update
                - watch
            - apiGroups:
                - networking.k8s.io
              resources:
                - networkpolicies
              verbs:
                - create
                - get
                - patch
                - update
                - watch
          serviceAccountName: ibm-mq
    strategy: deployment
  maintainers:
    - email: askmessaging@uk.ibm.com
      name: IBM MQ
  description: >
    [IBM MQ](https://www.ibm.com/products/mq) is messaging middleware that
    simplifies and accelerates

    the integration of diverse applications and business data across multiple
    platforms.

    It uses message queues to facilitate the exchanges of information and offers

    a single messaging solution for cloud, mobile, Internet of Things (IoT) and
    on-premises

    environments.


    The IBM MQ Operator for Red Hat OpenShift Container Platform provides

    an easy way to manage the life cycle of IBM MQ queue managers.


    IBM MQ is part of the [IBM Cloud Pak for
    Integration](https://www.ibm.com/cloud/cloud-pak-for-integration).


    ## Features


    * Creation and management of IBM MQ queue managers
      * Use of single-instance or multi-instance queue managers, for high availability
      * Integration with Cloud Pak for Integration Operations Dashboard
      * Single Sign-On (SSO) with the Cloud Pak for Integration, using the IBM Common Services IAM

    # Details


    ## Prerequisites


    * Red Hat OpenShift Container Platform V4.4 (Kubernetes 1.17)

    * If persistence is enabled you need to ensure a Storage Class is defined in
    your OpenShift cluster.


    ### Resources Required


    * The IBM MQ Operator requires 1 CPU core and 1 GB memory

    * Each IBM MQ Queue Manager defaults to 1 CPU core and 1 GB memory, but can
    be run with fewer resources with lower performance

    * The IBM Common Services Operator and its dependencies will be installed
    automatically when you install the IBM MQ Operator.  In addition, when the
    IBM MQ Operator first starts, it will install the IBM Licensing Operator and
    its dependencies.  If you are using the Cloud Pak for Integration license
    with the web server enabled, then the IBM Identity and Access Management
    Operator and IBM Management Ingress Operator and their dependencies will
    also be installed automatically.  For more information, see [Hardware
    requirements and recommendations for IBM Common
    Services](https://www.ibm.com/support/knowledgecenter/SSHKN6/installer/3.x.x/hardware_sizing_reqs.html)
    and [Dependencies of the IBM Cloud Platform Common
    Services](https://www.ibm.com/support/knowledgecenter/SSHKN6/installer/3.x.x/disable_and_enable_services.html)


    # Installing


    See [Installing and uninstalling the IBM MQ Operator on
    OpenShift](https://www.ibm.com/support/knowledgecenter/SSFKSJ_9.1.0/com.ibm.mq.ctr.doc/ctr_install_uninstall.htm). 
    Operators need to be installed by a cluster administrator.


    ## Configuration


    See [Deploying MQ in
    containers](https://www.ibm.com/support/knowledgecenter/SSFKSJ_9.1.0/com.ibm.mq.ctr.doc/deploy_ctr.htm). 
    Queue managers can be installed by a project (namespace) administrator.


    ## SecurityContextConstraints Requirements


    * IBM MQ runs under the default `restricted` SecurityContextConstraints.
      
    ## Storage


    MQ is configured to use dynamic provisioning of ReadWriteMany (RWX)
    Persistent Volumes, which use a shared filesystem.

    MQ is affected by other limits applied to the file system (such as limiting
    the number of file locks in AWS EFS). See [testing
    statement](https://www.ibm.com/support/pages/testing-statement-ibm-mq-multi-instance-queue-manager-file-systems).


    ## Limitations


    * Supports only the `amd64` CPU architecture

    * Supports OpenShift Container Platform V4.4 onwards only

    * Do not edit the availability type of a QueueManager after initial creation

    * Do not edit the storage settings of a QueueManager after initial creation

    * Do not edit `spec.queueManager.name` after initial creation

    * The following alpha and beta APIs and features are used by the MQ
    operator:
      * `apiextensions.k8s.io/v1beta1` for Operator installation
      * `operators.coreos.com/v1alpha1` for Operator installation
      * `operator.ibm.com/v1alpha1` for installation of additional IBM common operators
      * `service.beta.openshift.io` annotations on Service, to provide a certificate for the webhook

    ## Documentation


    [IBM MQ Knowledge
    Center](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_9.1.0/)
  labels:
    name: ibm-mq
EOF