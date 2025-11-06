{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-crds".content = [
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "api-approved.kubernetes.io" = "https://github.com/kubernetes-csi/external-snapshotter/pull/814";
            "controller-gen.kubebuilder.io/version" = "v0.11.3";
          };
          creationTimestamp = null;
          name = "volumesnapshotclasses.snapshot.storage.k8s.io";
        };
        spec = {
          group = "snapshot.storage.k8s.io";
          names = {
            kind = "VolumeSnapshotClass";
            listKind = "VolumeSnapshotClassList";
            plural = "volumesnapshotclasses";
            shortNames = [
              "vsclass"
              "vsclasses"
            ];
            singular = "volumesnapshotclass";
          };
          scope = "Cluster";
          versions = [
            {
              additionalPrinterColumns = [
                {
                  jsonPath = ".driver";
                  name = "Driver";
                  type = "string";
                }
                {
                  description = "Determines whether a VolumeSnapshotContent created through the VolumeSnapshotClass should be deleted when its bound VolumeSnapshot is deleted.";
                  jsonPath = ".deletionPolicy";
                  name = "DeletionPolicy";
                  type = "string";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshotClass specifies parameters that a underlying storage system uses when creating a volume snapshot. A specific VolumeSnapshotClass is used by specifying its name in a VolumeSnapshot object. VolumeSnapshotClasses are non-namespaced";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    deletionPolicy = {
                      description = "deletionPolicy determines whether a VolumeSnapshotContent created through the VolumeSnapshotClass should be deleted when its bound VolumeSnapshot is deleted. Supported values are \"Retain\" and \"Delete\". \"Retain\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept. \"Delete\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted. Required.";
                      enum = [
                        "Delete"
                        "Retain"
                      ];
                      type = "string";
                    };
                    driver = {
                      description = "driver is the name of the storage driver that handles this VolumeSnapshotClass. Required.";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    parameters = {
                      additionalProperties = {
                        type = "string";
                      };
                      description = "parameters is a key-value map with storage driver specific parameters for creating snapshots. These values are opaque to Kubernetes.";
                      type = "object";
                    };
                  };
                  required = [
                    "deletionPolicy"
                    "driver"
                  ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
              subresources = { };
            }
            {
              additionalPrinterColumns = [
                {
                  jsonPath = ".driver";
                  name = "Driver";
                  type = "string";
                }
                {
                  description = "Determines whether a VolumeSnapshotContent created through the\nVolumeSnapshotClass should be deleted when its bound VolumeSnapshot is deleted.\n";
                  jsonPath = ".deletionPolicy";
                  name = "DeletionPolicy";
                  type = "string";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              deprecated = true;
              deprecationWarning = "snapshot.storage.k8s.io/v1beta1 VolumeSnapshotClass is deprecated; use snapshot.storage.k8s.io/v1 VolumeSnapshotClass";
              name = "v1beta1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshotClass specifies parameters that a underlying storage system uses when creating a volume snapshot. A specific VolumeSnapshotClass is used by specifying its name in a VolumeSnapshot object. VolumeSnapshotClasses are non-namespaced";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    deletionPolicy = {
                      description = "deletionPolicy determines whether a VolumeSnapshotContent created through the VolumeSnapshotClass should be deleted when its bound VolumeSnapshot is deleted. Supported values are \"Retain\" and \"Delete\". \"Retain\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept. \"Delete\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted. Required.";
                      enum = [
                        "Delete"
                        "Retain"
                      ];
                      type = "string";
                    };
                    driver = {
                      description = "driver is the name of the storage driver that handles this VolumeSnapshotClass. Required.";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    parameters = {
                      additionalProperties = {
                        type = "string";
                      };
                      description = "parameters is a key-value map with storage driver specific parameters for creating snapshots. These values are opaque to Kubernetes.";
                      type = "object";
                    };
                  };
                  required = [
                    "deletionPolicy"
                    "driver"
                  ];
                  type = "object";
                };
              };
              served = false;
              storage = false;
              subresources = { };
            }
          ];
        };
        status = {
          acceptedNames = {
            kind = "";
            plural = "";
          };
          conditions = [ ];
          storedVersions = [ ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "api-approved.kubernetes.io" = "https://github.com/kubernetes-csi/external-snapshotter/pull/814";
            "controller-gen.kubebuilder.io/version" = "v0.11.3";
          };
          creationTimestamp = null;
          name = "volumesnapshotcontents.snapshot.storage.k8s.io";
        };
        spec = {
          group = "snapshot.storage.k8s.io";
          names = {
            kind = "VolumeSnapshotContent";
            listKind = "VolumeSnapshotContentList";
            plural = "volumesnapshotcontents";
            shortNames = [
              "vsc"
              "vscs"
            ];
            singular = "volumesnapshotcontent";
          };
          scope = "Cluster";
          versions = [
            {
              additionalPrinterColumns = [
                {
                  description = "Indicates if the snapshot is ready to be used to restore a volume.";
                  jsonPath = ".status.readyToUse";
                  name = "ReadyToUse";
                  type = "boolean";
                }
                {
                  description = "Represents the complete size of the snapshot in bytes";
                  jsonPath = ".status.restoreSize";
                  name = "RestoreSize";
                  type = "integer";
                }
                {
                  description = "Determines whether this VolumeSnapshotContent and its physical snapshot on the underlying storage system should be deleted when its bound VolumeSnapshot is deleted.";
                  jsonPath = ".spec.deletionPolicy";
                  name = "DeletionPolicy";
                  type = "string";
                }
                {
                  description = "Name of the CSI driver used to create the physical snapshot on the underlying storage system.";
                  jsonPath = ".spec.driver";
                  name = "Driver";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshotClass to which this snapshot belongs.";
                  jsonPath = ".spec.volumeSnapshotClassName";
                  name = "VolumeSnapshotClass";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshot object to which this VolumeSnapshotContent object is bound.";
                  jsonPath = ".spec.volumeSnapshotRef.name";
                  name = "VolumeSnapshot";
                  type = "string";
                }
                {
                  description = "Namespace of the VolumeSnapshot object to which this VolumeSnapshotContent object is bound.";
                  jsonPath = ".spec.volumeSnapshotRef.namespace";
                  name = "VolumeSnapshotNamespace";
                  type = "string";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshotContent represents the actual \"on-disk\" snapshot object in the underlying storage system";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    spec = {
                      description = "spec defines properties of a VolumeSnapshotContent created by the underlying storage system. Required.";
                      properties = {
                        deletionPolicy = {
                          description = "deletionPolicy determines whether this VolumeSnapshotContent and its physical snapshot on the underlying storage system should be deleted when its bound VolumeSnapshot is deleted. Supported values are \"Retain\" and \"Delete\". \"Retain\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept. \"Delete\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted. For dynamically provisioned snapshots, this field will automatically be filled in by the CSI snapshotter sidecar with the \"DeletionPolicy\" field defined in the corresponding VolumeSnapshotClass. For pre-existing snapshots, users MUST specify this field when creating the VolumeSnapshotContent object. Required.";
                          enum = [
                            "Delete"
                            "Retain"
                          ];
                          type = "string";
                        };
                        driver = {
                          description = "driver is the name of the CSI driver used to create the physical snapshot on the underlying storage system. This MUST be the same as the name returned by the CSI GetPluginName() call for that driver. Required.";
                          type = "string";
                        };
                        source = {
                          description = "source specifies whether the snapshot is (or should be) dynamically provisioned or already exists, and just requires a Kubernetes object representation. This field is immutable after creation. Required.";
                          oneOf = [
                            { required = [ "snapshotHandle" ]; }
                            { required = [ "volumeHandle" ]; }
                          ];
                          properties = {
                            snapshotHandle = {
                              description = "snapshotHandle specifies the CSI \"snapshot_id\" of a pre-existing snapshot on the underlying storage system for which a Kubernetes object representation was (or should be) created. This field is immutable.";
                              type = "string";
                            };
                            volumeHandle = {
                              description = "volumeHandle specifies the CSI \"volume_id\" of the volume from which a snapshot should be dynamically taken from. This field is immutable.";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        sourceVolumeMode = {
                          description = "SourceVolumeMode is the mode of the volume whose snapshot is taken. Can be either “Filesystem” or “Block”. If not specified, it indicates the source volume's mode is unknown. This field is immutable. This field is an alpha field.";
                          type = "string";
                        };
                        volumeSnapshotClassName = {
                          description = "name of the VolumeSnapshotClass from which this snapshot was (or will be) created. Note that after provisioning, the VolumeSnapshotClass may be deleted or recreated with different set of values, and as such, should not be referenced post-snapshot creation.";
                          type = "string";
                        };
                        volumeSnapshotRef = {
                          description = "volumeSnapshotRef specifies the VolumeSnapshot object to which this VolumeSnapshotContent object is bound. VolumeSnapshot.Spec.VolumeSnapshotContentName field must reference to this VolumeSnapshotContent's name for the bidirectional binding to be valid. For a pre-existing VolumeSnapshotContent object, name and namespace of the VolumeSnapshot object MUST be provided for binding to happen. This field is immutable after creation. Required.";
                          properties = {
                            apiVersion = {
                              description = "API version of the referent.";
                              type = "string";
                            };
                            fieldPath = {
                              description = "If referring to a piece of an object instead of\nan entire object, this string should contain a valid JSON/Go\nfield access statement, such as desiredState.manifest.containers[2].\nFor example, if the object reference is to a container within\na pod, this would take on a value like: \"spec.containers{name}\"\n(where \"name\" refers to the name of the container that triggered\nthe event) or if no container name is specified \"spec.containers[2]\"\n(container with index 2 in this pod). This syntax is chosen\nonly to have some well-defined way of referencing a part of\nan object. TODO: this design is not final and this field is\nsubject to change in the future.\n";
                              type = "string";
                            };
                            kind = {
                              description = "Kind of the referent. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                              type = "string";
                            };
                            name = {
                              description = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names";
                              type = "string";
                            };
                            namespace = {
                              description = "Namespace of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/";
                              type = "string";
                            };
                            resourceVersion = {
                              description = "Specific resourceVersion to which this reference\nis made, if any. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency\n";
                              type = "string";
                            };
                            uid = {
                              description = "UID of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids";
                              type = "string";
                            };
                          };
                          type = "object";
                          x-kubernetes-map-type = "atomic";
                        };
                      };
                      required = [
                        "deletionPolicy"
                        "driver"
                        "source"
                        "volumeSnapshotRef"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "status represents the current information of a snapshot.";
                      properties = {
                        creationTime = {
                          description = "creationTime is the timestamp when the point-in-time\nsnapshot is taken by the underlying storage system. In dynamic snapshot\ncreation case, this field will be filled in by the CSI snapshotter\nsidecar with the \"creation_time\" value returned from CSI \"CreateSnapshot\"\ngRPC call. For a pre-existing snapshot, this field will be filled\nwith the \"creation_time\" value returned from the CSI \"ListSnapshots\"\ngRPC call if the driver supports it. If not specified, it indicates\nthe creation time is unknown. The format of this field is a Unix\nnanoseconds time encoded as an int64. On Unix, the command `date\n+%s%N` returns the current time in nanoseconds since 1970-01-01\n00:00:00 UTC.\n";
                          format = "int64";
                          type = "integer";
                        };
                        error = {
                          description = "error is the last observed error during snapshot creation, if any. Upon success after retry, this error field will be cleared.";
                          properties = {
                            message = {
                              description = "message is a string detailing the encountered error\nduring snapshot creation if specified. NOTE: message may be\nlogged, and it should not contain sensitive information.\n";
                              type = "string";
                            };
                            time = {
                              description = "time is the timestamp when the error was encountered.";
                              format = "date-time";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        readyToUse = {
                          description = "readyToUse indicates if a snapshot is ready to be used to restore a volume. In dynamic snapshot creation case, this field will be filled in by the CSI snapshotter sidecar with the \"ready_to_use\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"ready_to_use\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it, otherwise, this field will be set to \"True\". If not specified, it means the readiness of a snapshot is unknown.";
                          type = "boolean";
                        };
                        restoreSize = {
                          description = "restoreSize represents the complete size of the snapshot in bytes. In dynamic snapshot creation case, this field will be filled in by the CSI snapshotter sidecar with the \"size_bytes\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"size_bytes\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. When restoring a volume from this snapshot, the size of the volume MUST NOT be smaller than the restoreSize if it is specified, otherwise the restoration will fail. If not specified, it indicates that the size is unknown.";
                          format = "int64";
                          minimum = 0;
                          type = "integer";
                        };
                        snapshotHandle = {
                          description = "snapshotHandle is the CSI \"snapshot_id\" of a snapshot on the underlying storage system. If not specified, it indicates that dynamic snapshot creation has either failed or it is still in progress.";
                          type = "string";
                        };
                        volumeGroupSnapshotContentName = {
                          description = "VolumeGroupSnapshotContentName is the name of the VolumeGroupSnapshotContent of which this VolumeSnapshotContent is a part of.";
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
              subresources = {
                status = { };
              };
            }
            {
              additionalPrinterColumns = [
                {
                  description = "Indicates if the snapshot is ready to be used to restore a volume.";
                  jsonPath = ".status.readyToUse";
                  name = "ReadyToUse";
                  type = "boolean";
                }
                {
                  description = "Represents the complete size of the snapshot in bytes";
                  jsonPath = ".status.restoreSize";
                  name = "RestoreSize";
                  type = "integer";
                }
                {
                  description = "Determines whether this VolumeSnapshotContent and its physical snapshot on the underlying storage system should be deleted when its bound VolumeSnapshot is deleted.";
                  jsonPath = ".spec.deletionPolicy";
                  name = "DeletionPolicy";
                  type = "string";
                }
                {
                  description = "Name of the CSI driver used to create the physical snapshot on the underlying storage system.";
                  jsonPath = ".spec.driver";
                  name = "Driver";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshotClass to which this snapshot belongs.";
                  jsonPath = ".spec.volumeSnapshotClassName";
                  name = "VolumeSnapshotClass";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshot object to which this VolumeSnapshotContent object is bound.";
                  jsonPath = ".spec.volumeSnapshotRef.name";
                  name = "VolumeSnapshot";
                  type = "string";
                }
                {
                  description = "Namespace of the VolumeSnapshot object to which this VolumeSnapshotContent object is bound.";
                  jsonPath = ".spec.volumeSnapshotRef.namespace";
                  name = "VolumeSnapshotNamespace";
                  type = "string";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              deprecated = true;
              deprecationWarning = "snapshot.storage.k8s.io/v1beta1 VolumeSnapshotContent is deprecated; use snapshot.storage.k8s.io/v1 VolumeSnapshotContent";
              name = "v1beta1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshotContent represents the actual \"on-disk\" snapshot object in the underlying storage system";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    spec = {
                      description = "spec defines properties of a VolumeSnapshotContent created by the underlying storage system. Required.";
                      properties = {
                        deletionPolicy = {
                          description = "deletionPolicy determines whether this VolumeSnapshotContent and its physical snapshot on the underlying storage system should be deleted when its bound VolumeSnapshot is deleted. Supported values are \"Retain\" and \"Delete\". \"Retain\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept. \"Delete\" means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted. For dynamically provisioned snapshots, this field will automatically be filled in by the CSI snapshotter sidecar with the \"DeletionPolicy\" field defined in the corresponding VolumeSnapshotClass. For pre-existing snapshots, users MUST specify this field when creating the  VolumeSnapshotContent object. Required.";
                          enum = [
                            "Delete"
                            "Retain"
                          ];
                          type = "string";
                        };
                        driver = {
                          description = "driver is the name of the CSI driver used to create the physical snapshot on the underlying storage system. This MUST be the same as the name returned by the CSI GetPluginName() call for that driver. Required.";
                          type = "string";
                        };
                        source = {
                          description = "source specifies whether the snapshot is (or should be) dynamically provisioned or already exists, and just requires a Kubernetes object representation. This field is immutable after creation. Required.";
                          properties = {
                            snapshotHandle = {
                              description = "snapshotHandle specifies the CSI \"snapshot_id\" of a pre-existing snapshot on the underlying storage system for which a Kubernetes object representation was (or should be) created. This field is immutable.";
                              type = "string";
                            };
                            volumeHandle = {
                              description = "volumeHandle specifies the CSI \"volume_id\" of the volume from which a snapshot should be dynamically taken from. This field is immutable.";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        volumeSnapshotClassName = {
                          description = "name of the VolumeSnapshotClass from which this snapshot was (or will be) created. Note that after provisioning, the VolumeSnapshotClass may be deleted or recreated with different set of values, and as such, should not be referenced post-snapshot creation.";
                          type = "string";
                        };
                        volumeSnapshotRef = {
                          description = "volumeSnapshotRef specifies the VolumeSnapshot object to which this VolumeSnapshotContent object is bound. VolumeSnapshot.Spec.VolumeSnapshotContentName field must reference to this VolumeSnapshotContent's name for the bidirectional binding to be valid. For a pre-existing VolumeSnapshotContent object, name and namespace of the VolumeSnapshot object MUST be provided for binding to happen. This field is immutable after creation. Required.";
                          properties = {
                            apiVersion = {
                              description = "API version of the referent.";
                              type = "string";
                            };
                            fieldPath = {
                              description = "If referring to a piece of an object instead of\nan entire object, this string should contain a valid JSON/Go\nfield access statement, such as desiredState.manifest.containers[2].\nFor example, if the object reference is to a container within\na pod, this would take on a value like: \"spec.containers{name}\"\n(where \"name\" refers to the name of the container that triggered\nthe event) or if no container name is specified \"spec.containers[2]\"\n(container with index 2 in this pod). This syntax is chosen\nonly to have some well-defined way of referencing a part of\nan object. TODO: this design is not final and this field is\nsubject to change in the future.\n";
                              type = "string";
                            };
                            kind = {
                              description = "Kind of the referent. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                              type = "string";
                            };
                            name = {
                              description = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names";
                              type = "string";
                            };
                            namespace = {
                              description = "Namespace of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/";
                              type = "string";
                            };
                            resourceVersion = {
                              description = "Specific resourceVersion to which this reference\nis made, if any. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency\n";
                              type = "string";
                            };
                            uid = {
                              description = "UID of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                      };
                      required = [
                        "deletionPolicy"
                        "driver"
                        "source"
                        "volumeSnapshotRef"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "status represents the current information of a snapshot.";
                      properties = {
                        creationTime = {
                          description = "creationTime is the timestamp when the point-in-time snapshot is taken by the underlying storage system. In dynamic snapshot creation case, this field will be filled in by the CSI snapshotter sidecar with the \"creation_time\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"creation_time\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. If not specified, it indicates the creation time is unknown. The format of this field is a Unix nanoseconds time encoded as an int64. On Unix, the command `date +%s%N` returns the current time in nanoseconds since 1970-01-01 00:00:00 UTC.";
                          format = "int64";
                          type = "integer";
                        };
                        error = {
                          description = "error is the last observed error during snapshot creation, if any. Upon success after retry, this error field will be cleared.";
                          properties = {
                            message = {
                              description = "message is a string detailing the encountered error\nduring snapshot creation if specified. NOTE: message may be\nlogged, and it should not contain sensitive information.\n";
                              type = "string";
                            };
                            time = {
                              description = "time is the timestamp when the error was encountered.";
                              format = "date-time";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        readyToUse = {
                          description = "readyToUse indicates if a snapshot is ready to be used to restore a volume. In dynamic snapshot creation case, this field will be filled in by the CSI snapshotter sidecar with the \"ready_to_use\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"ready_to_use\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it, otherwise, this field will be set to \"True\". If not specified, it means the readiness of a snapshot is unknown.";
                          type = "boolean";
                        };
                        restoreSize = {
                          description = "restoreSize represents the complete size of the snapshot in bytes. In dynamic snapshot creation case, this field will be filled in by the CSI snapshotter sidecar with the \"size_bytes\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"size_bytes\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. When restoring a volume from this snapshot, the size of the volume MUST NOT be smaller than the restoreSize if it is specified, otherwise the restoration will fail. If not specified, it indicates that the size is unknown.";
                          format = "int64";
                          minimum = 0;
                          type = "integer";
                        };
                        snapshotHandle = {
                          description = "snapshotHandle is the CSI \"snapshot_id\" of a snapshot on the underlying storage system. If not specified, it indicates that dynamic snapshot creation has either failed or it is still in progress.";
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = false;
              storage = false;
              subresources = {
                status = { };
              };
            }
          ];
        };
        status = {
          acceptedNames = {
            kind = "";
            plural = "";
          };
          conditions = [ ];
          storedVersions = [ ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "api-approved.kubernetes.io" = "https://github.com/kubernetes-csi/external-snapshotter/pull/814";
            "controller-gen.kubebuilder.io/version" = "v0.11.3";
          };
          creationTimestamp = null;
          name = "volumesnapshots.snapshot.storage.k8s.io";
        };
        spec = {
          group = "snapshot.storage.k8s.io";
          names = {
            kind = "VolumeSnapshot";
            listKind = "VolumeSnapshotList";
            plural = "volumesnapshots";
            shortNames = [ "vs" ];
            singular = "volumesnapshot";
          };
          scope = "Namespaced";
          versions = [
            {
              additionalPrinterColumns = [
                {
                  description = "Indicates if the snapshot is ready to be used to restore a volume.";
                  jsonPath = ".status.readyToUse";
                  name = "ReadyToUse";
                  type = "boolean";
                }
                {
                  description = "If a new snapshot needs to be created, this contains the name of the source PVC from which this snapshot was (or will be) created.";
                  jsonPath = ".spec.source.persistentVolumeClaimName";
                  name = "SourcePVC";
                  type = "string";
                }
                {
                  description = "If a snapshot already exists, this contains the name of the existing VolumeSnapshotContent object representing the existing snapshot.";
                  jsonPath = ".spec.source.volumeSnapshotContentName";
                  name = "SourceSnapshotContent";
                  type = "string";
                }
                {
                  description = "Represents the minimum size of volume required to rehydrate from this snapshot.";
                  jsonPath = ".status.restoreSize";
                  name = "RestoreSize";
                  type = "string";
                }
                {
                  description = "The name of the VolumeSnapshotClass requested by the VolumeSnapshot.";
                  jsonPath = ".spec.volumeSnapshotClassName";
                  name = "SnapshotClass";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshotContent object to which the VolumeSnapshot object intends to bind to. Please note that verification of binding actually requires checking both VolumeSnapshot and VolumeSnapshotContent to ensure both are pointing at each other. Binding MUST be verified prior to usage of this object.";
                  jsonPath = ".status.boundVolumeSnapshotContentName";
                  name = "SnapshotContent";
                  type = "string";
                }
                {
                  description = "Timestamp when the point-in-time snapshot was taken by the underlying storage system.";
                  jsonPath = ".status.creationTime";
                  name = "CreationTime";
                  type = "date";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshot is a user's request for either creating a point-in-time snapshot of a persistent volume, or binding to a pre-existing snapshot.";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    spec = {
                      description = "spec defines the desired characteristics of a snapshot requested by a user. More info: https://kubernetes.io/docs/concepts/storage/volume-snapshots#volumesnapshots Required.";
                      properties = {
                        source = {
                          description = "source specifies where a snapshot will be created from. This field is immutable after creation. Required.";
                          oneOf = [
                            { required = [ "persistentVolumeClaimName" ]; }
                            { required = [ "volumeSnapshotContentName" ]; }
                          ];
                          properties = {
                            persistentVolumeClaimName = {
                              description = "persistentVolumeClaimName specifies the name of the PersistentVolumeClaim object representing the volume from which a snapshot should be created. This PVC is assumed to be in the same namespace as the VolumeSnapshot object. This field should be set if the snapshot does not exists, and needs to be created. This field is immutable.";
                              type = "string";
                            };
                            volumeSnapshotContentName = {
                              description = "volumeSnapshotContentName specifies the name of a pre-existing VolumeSnapshotContent object representing an existing volume snapshot. This field should be set if the snapshot already exists and only needs a representation in Kubernetes. This field is immutable.";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        volumeSnapshotClassName = {
                          description = "VolumeSnapshotClassName is the name of the VolumeSnapshotClass\nrequested by the VolumeSnapshot. VolumeSnapshotClassName may be\nleft nil to indicate that the default SnapshotClass should be used.\nA given cluster may have multiple default Volume SnapshotClasses:\none default per CSI Driver. If a VolumeSnapshot does not specify\na SnapshotClass, VolumeSnapshotSource will be checked to figure\nout what the associated CSI Driver is, and the default VolumeSnapshotClass\nassociated with that CSI Driver will be used. If more than one VolumeSnapshotClass\nexist for a given CSI Driver and more than one have been marked\nas default, CreateSnapshot will fail and generate an event. Empty\nstring is not allowed for this field.\n";
                          type = "string";
                        };
                      };
                      required = [ "source" ];
                      type = "object";
                    };
                    status = {
                      description = "status represents the current information of a snapshot. Consumers must verify binding between VolumeSnapshot and VolumeSnapshotContent objects is successful (by validating that both VolumeSnapshot and VolumeSnapshotContent point at each other) before using this object.";
                      properties = {
                        boundVolumeSnapshotContentName = {
                          description = "boundVolumeSnapshotContentName is the name of the VolumeSnapshotContent\nobject to which this VolumeSnapshot object intends to bind to. If\nnot specified, it indicates that the VolumeSnapshot object has not\nbeen successfully bound to a VolumeSnapshotContent object yet. NOTE:\nTo avoid possible security issues, consumers must verify binding\nbetween VolumeSnapshot and VolumeSnapshotContent objects is successful\n(by validating that both VolumeSnapshot and VolumeSnapshotContent\npoint at each other) before using this object.\n";
                          type = "string";
                        };
                        creationTime = {
                          description = "creationTime is the timestamp when the point-in-time snapshot is taken by the underlying storage system. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"creation_time\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"creation_time\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. If not specified, it may indicate that the creation time of the snapshot is unknown.";
                          format = "date-time";
                          type = "string";
                        };
                        error = {
                          description = "error is the last observed error during snapshot creation, if any. This field could be helpful to upper level controllers(i.e., application controller) to decide whether they should continue on waiting for the snapshot to be created based on the type of error reported. The snapshot controller will keep retrying when an error occurs during the snapshot creation. Upon success, this error field will be cleared.";
                          properties = {
                            message = {
                              description = "message is a string detailing the encountered error during snapshot creation if specified. NOTE: message may be logged, and it should not contain sensitive information.";
                              type = "string";
                            };
                            time = {
                              description = "time is the timestamp when the error was encountered.";
                              format = "date-time";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        readyToUse = {
                          description = "readyToUse indicates if the snapshot is ready to be used to restore a volume. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"ready_to_use\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"ready_to_use\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it, otherwise, this field will be set to \"True\". If not specified, it means the readiness of a snapshot is unknown.";
                          type = "boolean";
                        };
                        restoreSize = {
                          description = "restoreSize represents the minimum size of volume required to create a volume from this snapshot. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"size_bytes\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"size_bytes\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. When restoring a volume from this snapshot, the size of the volume MUST NOT be smaller than the restoreSize if it is specified, otherwise the restoration will fail. If not specified, it indicates that the size is unknown.";
                          pattern = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$";
                          type = "string";
                          x-kubernetes-int-or-string = true;
                        };
                        volumeGroupSnapshotName = {
                          description = "VolumeGroupSnapshotName is the name of the VolumeGroupSnapshot of which this VolumeSnapshot is a part of.";
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
              subresources = {
                status = { };
              };
            }
            {
              additionalPrinterColumns = [
                {
                  description = "Indicates if the snapshot is ready to be used to restore a volume.";
                  jsonPath = ".status.readyToUse";
                  name = "ReadyToUse";
                  type = "boolean";
                }
                {
                  description = "If a new snapshot needs to be created, this contains the name of the source PVC from which this snapshot was (or will be) created.";
                  jsonPath = ".spec.source.persistentVolumeClaimName";
                  name = "SourcePVC";
                  type = "string";
                }
                {
                  description = "If a snapshot already exists, this contains the name of the existing VolumeSnapshotContent object representing the existing snapshot.";
                  jsonPath = ".spec.source.volumeSnapshotContentName";
                  name = "SourceSnapshotContent";
                  type = "string";
                }
                {
                  description = "Represents the minimum size of volume required to rehydrate from this snapshot.";
                  jsonPath = ".status.restoreSize";
                  name = "RestoreSize";
                  type = "string";
                }
                {
                  description = "The name of the VolumeSnapshotClass requested by the VolumeSnapshot.";
                  jsonPath = ".spec.volumeSnapshotClassName";
                  name = "SnapshotClass";
                  type = "string";
                }
                {
                  description = "Name of the VolumeSnapshotContent object to which the VolumeSnapshot object intends to bind to. Please note that verification of binding actually requires checking both VolumeSnapshot and VolumeSnapshotContent to ensure both are pointing at each other. Binding MUST be verified prior to usage of this object.";
                  jsonPath = ".status.boundVolumeSnapshotContentName";
                  name = "SnapshotContent";
                  type = "string";
                }
                {
                  description = "Timestamp when the point-in-time snapshot was taken by the underlying storage system.";
                  jsonPath = ".status.creationTime";
                  name = "CreationTime";
                  type = "date";
                }
                {
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              deprecated = true;
              deprecationWarning = "snapshot.storage.k8s.io/v1beta1 VolumeSnapshot is deprecated; use snapshot.storage.k8s.io/v1 VolumeSnapshot";
              name = "v1beta1";
              schema = {
                openAPIV3Schema = {
                  description = "VolumeSnapshot is a user's request for either creating a point-in-time snapshot of a persistent volume, or binding to a pre-existing snapshot.";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation\nof an object. Servers should convert recognized schemas to the latest\ninternal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources\n";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this\nobject represents. Servers may infer this from the endpoint the client\nsubmits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds\n";
                      type = "string";
                    };
                    spec = {
                      description = "spec defines the desired characteristics of a snapshot requested\nby a user. More info: https://kubernetes.io/docs/concepts/storage/volume-snapshots#volumesnapshots\nRequired.\n";
                      properties = {
                        source = {
                          description = "source specifies where a snapshot will be created from. This field is immutable after creation. Required.";
                          properties = {
                            persistentVolumeClaimName = {
                              description = "persistentVolumeClaimName specifies the name of the PersistentVolumeClaim object representing the volume from which a snapshot should be created. This PVC is assumed to be in the same namespace as the VolumeSnapshot object. This field should be set if the snapshot does not exists, and needs to be created. This field is immutable.";
                              type = "string";
                            };
                            volumeSnapshotContentName = {
                              description = "volumeSnapshotContentName specifies the name of a pre-existing VolumeSnapshotContent object representing an existing volume snapshot. This field should be set if the snapshot already exists and only needs a representation in Kubernetes. This field is immutable.";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        volumeSnapshotClassName = {
                          description = "VolumeSnapshotClassName is the name of the VolumeSnapshotClass\nrequested by the VolumeSnapshot. VolumeSnapshotClassName may be\nleft nil to indicate that the default SnapshotClass should be used.\nA given cluster may have multiple default Volume SnapshotClasses:\none default per CSI Driver. If a VolumeSnapshot does not specify\na SnapshotClass, VolumeSnapshotSource will be checked to figure\nout what the associated CSI Driver is, and the default VolumeSnapshotClass\nassociated with that CSI Driver will be used. If more than one VolumeSnapshotClass\nexist for a given CSI Driver and more than one have been marked\nas default, CreateSnapshot will fail and generate an event. Empty\nstring is not allowed for this field.\n";
                          type = "string";
                        };
                      };
                      required = [ "source" ];
                      type = "object";
                    };
                    status = {
                      description = "status represents the current information of a snapshot. Consumers must verify binding between VolumeSnapshot and VolumeSnapshotContent objects is successful (by validating that both VolumeSnapshot and VolumeSnapshotContent point at each other) before using this object.";
                      properties = {
                        boundVolumeSnapshotContentName = {
                          description = "boundVolumeSnapshotContentName is the name of the VolumeSnapshotContent\nobject to which this VolumeSnapshot object intends to bind to. If\nnot specified, it indicates that the VolumeSnapshot object has not\nbeen successfully bound to a VolumeSnapshotContent object yet. NOTE:\nTo avoid possible security issues, consumers must verify binding\nbetween VolumeSnapshot and VolumeSnapshotContent objects is successful\n(by validating that both VolumeSnapshot and VolumeSnapshotContent\npoint at each other) before using this object.\n";
                          type = "string";
                        };
                        creationTime = {
                          description = "creationTime is the timestamp when the point-in-time snapshot is taken by the underlying storage system. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"creation_time\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"creation_time\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. If not specified, it may indicate that the creation time of the snapshot is unknown.";
                          format = "date-time";
                          type = "string";
                        };
                        error = {
                          description = "error is the last observed error during snapshot creation, if any. This field could be helpful to upper level controllers(i.e., application controller) to decide whether they should continue on waiting for the snapshot to be created based on the type of error reported. The snapshot controller will keep retrying when an error occurs during the snapshot creation. Upon success, this error field will be cleared.";
                          properties = {
                            message = {
                              description = "message is a string detailing the encountered error\nduring snapshot creation if specified. NOTE: message may be\nlogged, and it should not contain sensitive information.\n";
                              type = "string";
                            };
                            time = {
                              description = "time is the timestamp when the error was encountered.";
                              format = "date-time";
                              type = "string";
                            };
                          };
                          type = "object";
                        };
                        readyToUse = {
                          description = "readyToUse indicates if the snapshot is ready to be used to restore a volume. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"ready_to_use\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"ready_to_use\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it, otherwise, this field will be set to \"True\". If not specified, it means the readiness of a snapshot is unknown.";
                          type = "boolean";
                        };
                        restoreSize = {
                          description = "restoreSize represents the minimum size of volume required to create a volume from this snapshot. In dynamic snapshot creation case, this field will be filled in by the snapshot controller with the \"size_bytes\" value returned from CSI \"CreateSnapshot\" gRPC call. For a pre-existing snapshot, this field will be filled with the \"size_bytes\" value returned from the CSI \"ListSnapshots\" gRPC call if the driver supports it. When restoring a volume from this snapshot, the size of the volume MUST NOT be smaller than the restoreSize if it is specified, otherwise the restoration will fail. If not specified, it indicates that the size is unknown.";
                          pattern = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$";
                          type = "string";
                          x-kubernetes-int-or-string = true;
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = false;
              storage = false;
              subresources = {
                status = { };
              };
            }
          ];
        };
        status = {
          acceptedNames = {
            kind = "";
            plural = "";
          };
          conditions = [ ];
          storedVersions = [ ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "controller-gen.kubebuilder.io/version" = "v0.19.0";
          };
          name = "zfsbackups.zfs.openebs.io";
        };
        spec = {
          group = "zfs.openebs.io";
          names = {
            kind = "ZFSBackup";
            listKind = "ZFSBackupList";
            plural = "zfsbackups";
            shortNames = [ "zb" ];
            singular = "zfsbackup";
          };
          scope = "Namespaced";
          versions = [
            {
              additionalPrinterColumns = [
                {
                  description = "Previous snapshot for backup";
                  jsonPath = ".spec.prevSnapName";
                  name = "PrevSnap";
                  type = "string";
                }
                {
                  description = "Backup status";
                  jsonPath = ".status";
                  name = "Status";
                  type = "string";
                }
                {
                  description = "Age of the volume";
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSBackup describes a zfs backup resource created as a custom resource";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "ZFSBackupSpec is the spec for a ZFSBackup resource";
                      properties = {
                        backupDest = {
                          description = "BackupDest is the remote address for backup transfer";
                          minLength = 1;
                          pattern = "^([0-9]+.[0-9]+.[0-9]+.[0-9]+:[0-9]+)$";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is a name of the nodes where the source volume is";
                          minLength = 1;
                          type = "string";
                        };
                        prevSnapName = {
                          description = "PrevSnapName is the last completed-backup's snapshot name";
                          type = "string";
                        };
                        snapName = {
                          description = "SnapName is the snapshot name for backup";
                          minLength = 1;
                          type = "string";
                        };
                        volumeName = {
                          description = "VolumeName is a name of the volume for which this backup is destined";
                          minLength = 1;
                          type = "string";
                        };
                      };
                      required = [
                        "backupDest"
                        "ownerNodeID"
                        "volumeName"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "ZFSBackupStatus is to hold status of backup";
                      enum = [
                        "Init"
                        "Done"
                        "Failed"
                        "Pending"
                        "InProgress"
                        "Invalid"
                      ];
                      type = "string";
                    };
                  };
                  required = [
                    "spec"
                    "status"
                  ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
              subresources = { };
            }
          ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "controller-gen.kubebuilder.io/version" = "v0.19.0";
          };
          name = "zfsnodes.zfs.openebs.io";
        };
        spec = {
          group = "zfs.openebs.io";
          names = {
            kind = "ZFSNode";
            listKind = "ZFSNodeList";
            plural = "zfsnodes";
            shortNames = [ "zfsnode" ];
            singular = "zfsnode";
          };
          scope = "Namespaced";
          versions = [
            {
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSNode records information about all zfs pools available\nin a node. In general, the openebs node-agent creates the ZFSNode\nobject & periodically synchronizing the zfs pools available in the node.\nZFSNode has an owner reference pointing to the corresponding node object.";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    pools = {
                      items = {
                        description = "Pool specifies attributes of a given zfs pool that exists on the node.";
                        properties = {
                          free = {
                            anyOf = [
                              { type = "integer"; }
                              { type = "string"; }
                            ];
                            description = "Free specifies the available capacity of zfs pool.";
                            pattern = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$";
                            x-kubernetes-int-or-string = true;
                          };
                          name = {
                            description = "Name of the zfs pool.";
                            minLength = 1;
                            type = "string";
                          };
                          used = {
                            anyOf = [
                              { type = "integer"; }
                              { type = "string"; }
                            ];
                            description = "Used specifies the used capacity of zfs pool.";
                            pattern = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$";
                            x-kubernetes-int-or-string = true;
                          };
                          uuid = {
                            description = "UUID denotes a unique identity of a zfs pool.";
                            minLength = 1;
                            type = "string";
                          };
                        };
                        required = [
                          "free"
                          "name"
                          "used"
                          "uuid"
                        ];
                        type = "object";
                      };
                      type = "array";
                    };
                  };
                  required = [ "pools" ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
            }
          ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "controller-gen.kubebuilder.io/version" = "v0.19.0";
          };
          name = "zfsrestores.zfs.openebs.io";
        };
        spec = {
          group = "zfs.openebs.io";
          names = {
            kind = "ZFSRestore";
            listKind = "ZFSRestoreList";
            plural = "zfsrestores";
            singular = "zfsrestore";
          };
          scope = "Namespaced";
          versions = [
            {
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSRestore describes a cstor restore resource created as a custom resource";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "ZFSRestoreSpec is the spec for a ZFSRestore resource";
                      properties = {
                        ownerNodeID = {
                          description = "owner node name where restore volume is present";
                          minLength = 1;
                          type = "string";
                        };
                        restoreSrc = {
                          description = "it can be ip:port in case of restore from remote or volumeName in case of local restore";
                          minLength = 1;
                          pattern = "^([0-9]+.[0-9]+.[0-9]+.[0-9]+:[0-9]+)$";
                          type = "string";
                        };
                        volumeName = {
                          description = "volume name to where restore has to be performed";
                          minLength = 1;
                          type = "string";
                        };
                      };
                      required = [
                        "ownerNodeID"
                        "restoreSrc"
                        "volumeName"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "ZFSRestoreStatus is to hold result of action.";
                      enum = [
                        "Init"
                        "Done"
                        "Failed"
                        "Pending"
                        "InProgress"
                        "Invalid"
                      ];
                      type = "string";
                    };
                    volSpec = {
                      description = "VolumeInfo defines ZFS volume parameters for all modes in which\nZFS volumes can be created like - ZFS volume with filesystem,\nZFS Volume exposed as zfs or ZFS volume exposed as raw block device.\nSome of the parameters can be only set during creation time\n(as specified in the details of the parameter), and a few are editable.\nIn case of Cloned volumes, the parameters are assigned the same values\nas the source volume.";
                      properties = {
                        capacity = {
                          description = "Capacity of the volume";
                          minLength = 1;
                          type = "string";
                        };
                        compression = {
                          description = "Compression specifies the block-level compression algorithm to be applied to the ZFS Volume.\nThe value \"on\" indicates ZFS to use the default compression algorithm. The default compression\nalgorithm used by ZFS will be either lzjb or, if the lz4_compress feature is enabled, lz4.\nCompression property can be edited after the volume has been created. The change will only\nbe applied to the newly-written data. For instance, if the Volume was created with \"off\" and\nthe next day the compression was modified to \"on\", the data written prior to setting \"on\" will\nnot be compressed.\nDefault Value: off.";
                          pattern = "^(on|off|lzjb|zstd(?:-fast|-[1-9]|-1[0-9])?|gzip(?:-[1-9])?|zle|lz4)$";
                          type = "string";
                        };
                        dedup = {
                          description = "Deduplication is the process for removing redundant data at the block level,\nreducing the total amount of data stored. If a file system has the dedup property\nenabled, duplicate data blocks are removed synchronously.\nThe result is that only unique data is stored and common components are shared among files.\nDeduplication can consume significant processing power (CPU) and memory as well as generate additional disk IO.\nBefore creating a pool with deduplication enabled, ensure that you have planned your hardware\nrequirements appropriately and implemented appropriate recovery practices, such as regular backups.\nAs an alternative to deduplication consider using compression=lz4, as a less resource-intensive alternative.\nshould be enabled on the zvol.\nDedup property can be edited after the volume has been created.\nDefault Value: off.";
                          enum = [
                            "on"
                            "off"
                          ];
                          type = "string";
                        };
                        encryption = {
                          description = "Enabling the encryption feature allows for the creation of\nencrypted filesystems and volumes. ZFS will encrypt file and zvol data,\nfile attributes, ACLs, permission bits, directory listings, FUID mappings,\nand userused / groupused data. ZFS will not encrypt metadata related to the\npool structure, including dataset and snapshot names, dataset hierarchy,\nproperties, file size, file holes, and deduplication tables\n(though the deduplicated data itself is encrypted).\nDefault Value: off.";
                          pattern = "^(on|off|aes-128-[c,g]cm|aes-192-[c,g]cm|aes-256-[c,g]cm)$";
                          type = "string";
                        };
                        fsType = {
                          description = "FsType specifies filesystem type for the zfs volume/dataset.\nIf FsType is provided as \"zfs\", then the driver will create a\nZFS dataset, formatting is not required as underlying filesystem is ZFS anyway.\nIf FsType is ext2, ext3, ext4 or xfs, then the driver will create a ZVOL and\nformat the volume accordingly.\nFsType can not be modified once volume has been provisioned.\nDefault Value: ext4.";
                          type = "string";
                        };
                        keyformat = {
                          description = "KeyFormat specifies format of the encryption key\nThe supported KeyFormats are passphrase, raw, hex.";
                          enum = [
                            "passphrase"
                            "raw"
                            "hex"
                          ];
                          type = "string";
                        };
                        keylocation = {
                          description = "KeyLocation is the location of key for the encryption";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is the Node ID where the ZPOOL is running which is where\nthe volume has been provisioned.\nOwnerNodeID can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        poolName = {
                          description = "poolName specifies the name of the pool where the volume has been created.\nPoolName can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        quotaType = {
                          description = "quotaType determines whether the dataset volume quota type is of type \"quota\" or \"refquota\".\nQuotaType can not be modified once volume has been provisioned.\nDefault Value: quota.";
                          enum = [
                            "quota"
                            "refquota"
                          ];
                          type = "string";
                        };
                        recordsize = {
                          description = "Specifies a suggested block size for files in the file system.\nThe size specified must be a power of two greater than or equal to 512 and less than or equal to 128 Kbytes.\nRecordSize property can be edited after the volume has been created.\nChanging the file system's recordsize affects only files created afterward; existing files are unaffected.\nDefault Value: 128k.";
                          minLength = 1;
                          type = "string";
                        };
                        shared = {
                          description = "Shared specifies whether the volume can be shared among multiple pods.\nIf it is not set to \"yes\", then the ZFS-LocalPV Driver will not allow\nthe volumes to be mounted by more than one pods.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        snapname = {
                          description = "SnapName specifies the name of the snapshot where the volume has been cloned from.\nSnapname can not be edited after the volume has been provisioned.";
                          type = "string";
                        };
                        thinProvision = {
                          description = "ThinProvision describes whether space reservation for the source volume is required or not.\nThe value \"yes\" indicates that volume should be thin provisioned and \"no\" means thick provisioning of the volume.\nIf thinProvision is set to \"yes\" then volume can be provisioned even if the ZPOOL does not\nhave the enough capacity.\nIf thinProvision is set to \"no\" then volume can be provisioned only if the ZPOOL has enough\ncapacity and capacity required by volume can be reserved.\nThinProvision can not be modified once volume has been provisioned.\nDefault Value: no.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        volblocksize = {
                          description = "VolBlockSize specifies the block size for the zvol.\nThe volsize can only be set to a multiple of volblocksize, and cannot be zero.\nVolBlockSize can not be edited after the volume has been provisioned.\nDefault Value: 8k.";
                          minLength = 1;
                          type = "string";
                        };
                        volumeType = {
                          description = "volumeType determines whether the volume is of type \"DATASET\" or \"ZVOL\".\nIf fstype provided in the storageclass is \"zfs\", a volume of type dataset will be created.\nIf \"ext4\", \"ext3\", \"ext2\" or \"xfs\" is mentioned as fstype\nin the storageclass, then a volume of type zvol will be created, which will be\nfurther formatted as the fstype provided in the storageclass.\nVolumeType can not be modified once volume has been provisioned.";
                          enum = [
                            "ZVOL"
                            "DATASET"
                          ];
                          type = "string";
                        };
                      };
                      required = [
                        "capacity"
                        "ownerNodeID"
                        "poolName"
                        "volumeType"
                      ];
                      type = "object";
                    };
                  };
                  required = [
                    "spec"
                    "status"
                  ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
            }
          ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "controller-gen.kubebuilder.io/version" = "v0.19.0";
          };
          name = "zfssnapshots.zfs.openebs.io";
        };
        spec = {
          group = "zfs.openebs.io";
          names = {
            kind = "ZFSSnapshot";
            listKind = "ZFSSnapshotList";
            plural = "zfssnapshots";
            shortNames = [ "zfssnap" ];
            singular = "zfssnapshot";
          };
          scope = "Namespaced";
          versions = [
            {
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSSnapshot represents a ZFS Snapshot of the zfsvolume";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "VolumeInfo defines ZFS volume parameters for all modes in which\nZFS volumes can be created like - ZFS volume with filesystem,\nZFS Volume exposed as zfs or ZFS volume exposed as raw block device.\nSome of the parameters can be only set during creation time\n(as specified in the details of the parameter), and a few are editable.\nIn case of Cloned volumes, the parameters are assigned the same values\nas the source volume.";
                      properties = {
                        capacity = {
                          description = "Capacity of the volume";
                          minLength = 1;
                          type = "string";
                        };
                        compression = {
                          description = "Compression specifies the block-level compression algorithm to be applied to the ZFS Volume.\nThe value \"on\" indicates ZFS to use the default compression algorithm. The default compression\nalgorithm used by ZFS will be either lzjb or, if the lz4_compress feature is enabled, lz4.\nCompression property can be edited after the volume has been created. The change will only\nbe applied to the newly-written data. For instance, if the Volume was created with \"off\" and\nthe next day the compression was modified to \"on\", the data written prior to setting \"on\" will\nnot be compressed.\nDefault Value: off.";
                          pattern = "^(on|off|lzjb|zstd(?:-fast|-[1-9]|-1[0-9])?|gzip(?:-[1-9])?|zle|lz4)$";
                          type = "string";
                        };
                        dedup = {
                          description = "Deduplication is the process for removing redundant data at the block level,\nreducing the total amount of data stored. If a file system has the dedup property\nenabled, duplicate data blocks are removed synchronously.\nThe result is that only unique data is stored and common components are shared among files.\nDeduplication can consume significant processing power (CPU) and memory as well as generate additional disk IO.\nBefore creating a pool with deduplication enabled, ensure that you have planned your hardware\nrequirements appropriately and implemented appropriate recovery practices, such as regular backups.\nAs an alternative to deduplication consider using compression=lz4, as a less resource-intensive alternative.\nshould be enabled on the zvol.\nDedup property can be edited after the volume has been created.\nDefault Value: off.";
                          enum = [
                            "on"
                            "off"
                          ];
                          type = "string";
                        };
                        encryption = {
                          description = "Enabling the encryption feature allows for the creation of\nencrypted filesystems and volumes. ZFS will encrypt file and zvol data,\nfile attributes, ACLs, permission bits, directory listings, FUID mappings,\nand userused / groupused data. ZFS will not encrypt metadata related to the\npool structure, including dataset and snapshot names, dataset hierarchy,\nproperties, file size, file holes, and deduplication tables\n(though the deduplicated data itself is encrypted).\nDefault Value: off.";
                          pattern = "^(on|off|aes-128-[c,g]cm|aes-192-[c,g]cm|aes-256-[c,g]cm)$";
                          type = "string";
                        };
                        fsType = {
                          description = "FsType specifies filesystem type for the zfs volume/dataset.\nIf FsType is provided as \"zfs\", then the driver will create a\nZFS dataset, formatting is not required as underlying filesystem is ZFS anyway.\nIf FsType is ext2, ext3, ext4 or xfs, then the driver will create a ZVOL and\nformat the volume accordingly.\nFsType can not be modified once volume has been provisioned.\nDefault Value: ext4.";
                          type = "string";
                        };
                        keyformat = {
                          description = "KeyFormat specifies format of the encryption key\nThe supported KeyFormats are passphrase, raw, hex.";
                          enum = [
                            "passphrase"
                            "raw"
                            "hex"
                          ];
                          type = "string";
                        };
                        keylocation = {
                          description = "KeyLocation is the location of key for the encryption";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is the Node ID where the ZPOOL is running which is where\nthe volume has been provisioned.\nOwnerNodeID can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        poolName = {
                          description = "poolName specifies the name of the pool where the volume has been created.\nPoolName can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        quotaType = {
                          description = "quotaType determines whether the dataset volume quota type is of type \"quota\" or \"refquota\".\nQuotaType can not be modified once volume has been provisioned.\nDefault Value: quota.";
                          enum = [
                            "quota"
                            "refquota"
                          ];
                          type = "string";
                        };
                        recordsize = {
                          description = "Specifies a suggested block size for files in the file system.\nThe size specified must be a power of two greater than or equal to 512 and less than or equal to 128 Kbytes.\nRecordSize property can be edited after the volume has been created.\nChanging the file system's recordsize affects only files created afterward; existing files are unaffected.\nDefault Value: 128k.";
                          minLength = 1;
                          type = "string";
                        };
                        shared = {
                          description = "Shared specifies whether the volume can be shared among multiple pods.\nIf it is not set to \"yes\", then the ZFS-LocalPV Driver will not allow\nthe volumes to be mounted by more than one pods.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        snapname = {
                          description = "SnapName specifies the name of the snapshot where the volume has been cloned from.\nSnapname can not be edited after the volume has been provisioned.";
                          type = "string";
                        };
                        thinProvision = {
                          description = "ThinProvision describes whether space reservation for the source volume is required or not.\nThe value \"yes\" indicates that volume should be thin provisioned and \"no\" means thick provisioning of the volume.\nIf thinProvision is set to \"yes\" then volume can be provisioned even if the ZPOOL does not\nhave the enough capacity.\nIf thinProvision is set to \"no\" then volume can be provisioned only if the ZPOOL has enough\ncapacity and capacity required by volume can be reserved.\nThinProvision can not be modified once volume has been provisioned.\nDefault Value: no.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        volblocksize = {
                          description = "VolBlockSize specifies the block size for the zvol.\nThe volsize can only be set to a multiple of volblocksize, and cannot be zero.\nVolBlockSize can not be edited after the volume has been provisioned.\nDefault Value: 8k.";
                          minLength = 1;
                          type = "string";
                        };
                        volumeType = {
                          description = "volumeType determines whether the volume is of type \"DATASET\" or \"ZVOL\".\nIf fstype provided in the storageclass is \"zfs\", a volume of type dataset will be created.\nIf \"ext4\", \"ext3\", \"ext2\" or \"xfs\" is mentioned as fstype\nin the storageclass, then a volume of type zvol will be created, which will be\nfurther formatted as the fstype provided in the storageclass.\nVolumeType can not be modified once volume has been provisioned.";
                          enum = [
                            "ZVOL"
                            "DATASET"
                          ];
                          type = "string";
                        };
                      };
                      required = [
                        "capacity"
                        "ownerNodeID"
                        "poolName"
                        "volumeType"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "SnapStatus string that reflects if the snapshot was created successfully";
                      properties = {
                        state = {
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [
                    "spec"
                    "status"
                  ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
            }
            {
              name = "v1alpha1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSSnapshot represents a ZFS Snapshot of the zfsvolume";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "VolumeInfo defines ZFS volume parameters for all modes in which\nZFS volumes can be created like - ZFS volume with filesystem,\nZFS Volume exposed as zfs or ZFS volume exposed as raw block device.\nSome of the parameters can be only set during creation time\n(as specified in the details of the parameter), and a few are editable.\nIn case of Cloned volumes, the parameters are assigned the same values\nas the source volume.";
                      properties = {
                        capacity = {
                          description = "Capacity of the volume";
                          minLength = 1;
                          type = "string";
                        };
                        compression = {
                          description = "Compression specifies the block-level compression algorithm to be applied to the ZFS Volume.\nThe value \"on\" indicates ZFS to use the default compression algorithm. The default compression\nalgorithm used by ZFS will be either lzjb or, if the lz4_compress feature is enabled, lz4.\nCompression property can be edited after the volume has been created. The change will only\nbe applied to the newly-written data. For instance, if the Volume was created with \"off\" and\nthe next day the compression was modified to \"on\", the data written prior to setting \"on\" will\nnot be compressed.\nDefault Value: off.";
                          pattern = "^(on|off|lzjb|gzip|gzip-[1-9]|zle|lz4)$";
                          type = "string";
                        };
                        dedup = {
                          description = "Deduplication is the process for removing redundant data at the block level,\nreducing the total amount of data stored. If a file system has the dedup property\nenabled, duplicate data blocks are removed synchronously.\nThe result is that only unique data is stored and common components are shared among files.\nDeduplication can consume significant processing power (CPU) and memory as well as generate additional disk IO.\nBefore creating a pool with deduplication enabled, ensure that you have planned your hardware\nrequirements appropriately and implemented appropriate recovery practices, such as regular backups.\nAs an alternative to deduplication consider using compression=lz4, as a less resource-intensive alternative.\nshould be enabled on the zvol.\nDedup property can be edited after the volume has been created.\nDefault Value: off.";
                          enum = [
                            "on"
                            "off"
                          ];
                          type = "string";
                        };
                        encryption = {
                          description = "Enabling the encryption feature allows for the creation of\nencrypted filesystems and volumes. ZFS will encrypt file and zvol data,\nfile attributes, ACLs, permission bits, directory listings, FUID mappings,\nand userused / groupused data. ZFS will not encrypt metadata related to the\npool structure, including dataset and snapshot names, dataset hierarchy,\nproperties, file size, file holes, and deduplication tables\n(though the deduplicated data itself is encrypted).\nDefault Value: off.";
                          pattern = "^(on|off|aes-128-[c,g]cm|aes-192-[c,g]cm|aes-256-[c,g]cm)$";
                          type = "string";
                        };
                        fsType = {
                          description = "FsType specifies filesystem type for the zfs volume/dataset.\nIf FsType is provided as \"zfs\", then the driver will create a\nZFS dataset, formatting is not required as underlying filesystem is ZFS anyway.\nIf FsType is ext2, ext3, ext4 or xfs, then the driver will create a ZVOL and\nformat the volume accordingly.\nFsType can not be modified once volume has been provisioned.\nDefault Value: ext4.";
                          type = "string";
                        };
                        keyformat = {
                          description = "KeyFormat specifies format of the encryption key\nThe supported KeyFormats are passphrase, raw, hex.";
                          enum = [
                            "passphrase"
                            "raw"
                            "hex"
                          ];
                          type = "string";
                        };
                        keylocation = {
                          description = "KeyLocation is the location of key for the encryption";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is the Node ID where the ZPOOL is running which is where\nthe volume has been provisioned.\nOwnerNodeID can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        poolName = {
                          description = "poolName specifies the name of the pool where the volume has been created.\nPoolName can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        recordsize = {
                          description = "Specifies a suggested block size for files in the file system.\nThe size specified must be a power of two greater than or equal to 512 and less than or equal to 128 Kbytes.\nRecordSize property can be edited after the volume has been created.\nChanging the file system's recordsize affects only files created afterward; existing files are unaffected.\nDefault Value: 128k.";
                          minLength = 1;
                          type = "string";
                        };
                        snapname = {
                          description = "SnapName specifies the name of the snapshot where the volume has been cloned from.\nSnapname can not be edited after the volume has been provisioned.";
                          type = "string";
                        };
                        thinProvision = {
                          description = "ThinProvision describes whether space reservation for the source volume is required or not.\nThe value \"yes\" indicates that volume should be thin provisioned and \"no\" means thick provisioning of the volume.\nIf thinProvision is set to \"yes\" then volume can be provisioned even if the ZPOOL does not\nhave the enough capacity.\nIf thinProvision is set to \"no\" then volume can be provisioned only if the ZPOOL has enough\ncapacity and capacity required by volume can be reserved.\nThinProvision can not be modified once volume has been provisioned.\nDefault Value: no.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        volblocksize = {
                          description = "VolBlockSize specifies the block size for the zvol.\nThe volsize can only be set to a multiple of volblocksize, and cannot be zero.\nVolBlockSize can not be edited after the volume has been provisioned.\nDefault Value: 8k.";
                          minLength = 1;
                          type = "string";
                        };
                        volumeType = {
                          description = "volumeType determines whether the volume is of type \"DATASET\" or \"ZVOL\".\nIf fstype provided in the storageclass is \"zfs\", a volume of type dataset will be created.\nIf \"ext4\", \"ext3\", \"ext2\" or \"xfs\" is mentioned as fstype\nin the storageclass, then a volume of type zvol will be created, which will be\nfurther formatted as the fstype provided in the storageclass.\nVolumeType can not be modified once volume has been provisioned.";
                          enum = [
                            "ZVOL"
                            "DATASET"
                          ];
                          type = "string";
                        };
                      };
                      required = [
                        "capacity"
                        "ownerNodeID"
                        "poolName"
                        "volumeType"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "SnapStatus string that reflects if the snapshot was created successfully";
                      properties = {
                        state = {
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [
                    "spec"
                    "status"
                  ];
                  type = "object";
                };
              };
              served = true;
              storage = false;
            }
          ];
        };
      }
      {
        apiVersion = "apiextensions.k8s.io/v1";
        kind = "CustomResourceDefinition";
        metadata = {
          annotations = {
            "controller-gen.kubebuilder.io/version" = "v0.19.0";
          };
          name = "zfsvolumes.zfs.openebs.io";
        };
        spec = {
          group = "zfs.openebs.io";
          names = {
            kind = "ZFSVolume";
            listKind = "ZFSVolumeList";
            plural = "zfsvolumes";
            shortNames = [
              "zfsvol"
              "zv"
            ];
            singular = "zfsvolume";
          };
          scope = "Namespaced";
          versions = [
            {
              additionalPrinterColumns = [
                {
                  description = "ZFS Pool where the volume is created";
                  jsonPath = ".spec.poolName";
                  name = "ZPool";
                  type = "string";
                }
                {
                  description = "Node where the volume is created";
                  jsonPath = ".spec.ownerNodeID";
                  name = "NodeID";
                  type = "string";
                }
                {
                  description = "Size of the volume";
                  jsonPath = ".spec.capacity";
                  name = "Size";
                  type = "string";
                }
                {
                  description = "Status of the volume";
                  jsonPath = ".status.state";
                  name = "Status";
                  type = "string";
                }
                {
                  description = "filesystem created on the volume";
                  jsonPath = ".spec.fsType";
                  name = "Filesystem";
                  type = "string";
                }
                {
                  description = "Age of the volume";
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSVolume represents a ZFS based volume";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "VolumeInfo defines ZFS volume parameters for all modes in which\nZFS volumes can be created like - ZFS volume with filesystem,\nZFS Volume exposed as zfs or ZFS volume exposed as raw block device.\nSome of the parameters can be only set during creation time\n(as specified in the details of the parameter), and a few are editable.\nIn case of Cloned volumes, the parameters are assigned the same values\nas the source volume.";
                      properties = {
                        capacity = {
                          description = "Capacity of the volume";
                          minLength = 1;
                          type = "string";
                        };
                        compression = {
                          description = "Compression specifies the block-level compression algorithm to be applied to the ZFS Volume.\nThe value \"on\" indicates ZFS to use the default compression algorithm. The default compression\nalgorithm used by ZFS will be either lzjb or, if the lz4_compress feature is enabled, lz4.\nCompression property can be edited after the volume has been created. The change will only\nbe applied to the newly-written data. For instance, if the Volume was created with \"off\" and\nthe next day the compression was modified to \"on\", the data written prior to setting \"on\" will\nnot be compressed.\nDefault Value: off.";
                          pattern = "^(on|off|lzjb|zstd(?:-fast|-[1-9]|-1[0-9])?|gzip(?:-[1-9])?|zle|lz4)$";
                          type = "string";
                        };
                        dedup = {
                          description = "Deduplication is the process for removing redundant data at the block level,\nreducing the total amount of data stored. If a file system has the dedup property\nenabled, duplicate data blocks are removed synchronously.\nThe result is that only unique data is stored and common components are shared among files.\nDeduplication can consume significant processing power (CPU) and memory as well as generate additional disk IO.\nBefore creating a pool with deduplication enabled, ensure that you have planned your hardware\nrequirements appropriately and implemented appropriate recovery practices, such as regular backups.\nAs an alternative to deduplication consider using compression=lz4, as a less resource-intensive alternative.\nshould be enabled on the zvol.\nDedup property can be edited after the volume has been created.\nDefault Value: off.";
                          enum = [
                            "on"
                            "off"
                          ];
                          type = "string";
                        };
                        encryption = {
                          description = "Enabling the encryption feature allows for the creation of\nencrypted filesystems and volumes. ZFS will encrypt file and zvol data,\nfile attributes, ACLs, permission bits, directory listings, FUID mappings,\nand userused / groupused data. ZFS will not encrypt metadata related to the\npool structure, including dataset and snapshot names, dataset hierarchy,\nproperties, file size, file holes, and deduplication tables\n(though the deduplicated data itself is encrypted).\nDefault Value: off.";
                          pattern = "^(on|off|aes-128-[c,g]cm|aes-192-[c,g]cm|aes-256-[c,g]cm)$";
                          type = "string";
                        };
                        fsType = {
                          description = "FsType specifies filesystem type for the zfs volume/dataset.\nIf FsType is provided as \"zfs\", then the driver will create a\nZFS dataset, formatting is not required as underlying filesystem is ZFS anyway.\nIf FsType is ext2, ext3, ext4 or xfs, then the driver will create a ZVOL and\nformat the volume accordingly.\nFsType can not be modified once volume has been provisioned.\nDefault Value: ext4.";
                          type = "string";
                        };
                        keyformat = {
                          description = "KeyFormat specifies format of the encryption key\nThe supported KeyFormats are passphrase, raw, hex.";
                          enum = [
                            "passphrase"
                            "raw"
                            "hex"
                          ];
                          type = "string";
                        };
                        keylocation = {
                          description = "KeyLocation is the location of key for the encryption";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is the Node ID where the ZPOOL is running which is where\nthe volume has been provisioned.\nOwnerNodeID can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        poolName = {
                          description = "poolName specifies the name of the pool where the volume has been created.\nPoolName can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        quotaType = {
                          description = "quotaType determines whether the dataset volume quota type is of type \"quota\" or \"refquota\".\nQuotaType can not be modified once volume has been provisioned.\nDefault Value: quota.";
                          enum = [
                            "quota"
                            "refquota"
                          ];
                          type = "string";
                        };
                        recordsize = {
                          description = "Specifies a suggested block size for files in the file system.\nThe size specified must be a power of two greater than or equal to 512 and less than or equal to 128 Kbytes.\nRecordSize property can be edited after the volume has been created.\nChanging the file system's recordsize affects only files created afterward; existing files are unaffected.\nDefault Value: 128k.";
                          minLength = 1;
                          type = "string";
                        };
                        shared = {
                          description = "Shared specifies whether the volume can be shared among multiple pods.\nIf it is not set to \"yes\", then the ZFS-LocalPV Driver will not allow\nthe volumes to be mounted by more than one pods.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        snapname = {
                          description = "SnapName specifies the name of the snapshot where the volume has been cloned from.\nSnapname can not be edited after the volume has been provisioned.";
                          type = "string";
                        };
                        thinProvision = {
                          description = "ThinProvision describes whether space reservation for the source volume is required or not.\nThe value \"yes\" indicates that volume should be thin provisioned and \"no\" means thick provisioning of the volume.\nIf thinProvision is set to \"yes\" then volume can be provisioned even if the ZPOOL does not\nhave the enough capacity.\nIf thinProvision is set to \"no\" then volume can be provisioned only if the ZPOOL has enough\ncapacity and capacity required by volume can be reserved.\nThinProvision can not be modified once volume has been provisioned.\nDefault Value: no.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        volblocksize = {
                          description = "VolBlockSize specifies the block size for the zvol.\nThe volsize can only be set to a multiple of volblocksize, and cannot be zero.\nVolBlockSize can not be edited after the volume has been provisioned.\nDefault Value: 8k.";
                          minLength = 1;
                          type = "string";
                        };
                        volumeType = {
                          description = "volumeType determines whether the volume is of type \"DATASET\" or \"ZVOL\".\nIf fstype provided in the storageclass is \"zfs\", a volume of type dataset will be created.\nIf \"ext4\", \"ext3\", \"ext2\" or \"xfs\" is mentioned as fstype\nin the storageclass, then a volume of type zvol will be created, which will be\nfurther formatted as the fstype provided in the storageclass.\nVolumeType can not be modified once volume has been provisioned.";
                          enum = [
                            "ZVOL"
                            "DATASET"
                          ];
                          type = "string";
                        };
                      };
                      required = [
                        "capacity"
                        "ownerNodeID"
                        "poolName"
                        "volumeType"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "VolStatus string that specifies the current state of the volume provisioning request.";
                      properties = {
                        state = {
                          description = "State specifies the current state of the volume provisioning request.\nThe state \"Pending\" means that the volume creation request has not\nprocessed yet. The state \"Ready\" means that the volume has been created\nand it is ready for the use.";
                          enum = [
                            "Pending"
                            "Ready"
                            "Failed"
                          ];
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = true;
              storage = true;
              subresources = { };
            }
            {
              additionalPrinterColumns = [
                {
                  description = "ZFS Pool where the volume is created";
                  jsonPath = ".spec.poolName";
                  name = "ZPool";
                  type = "string";
                }
                {
                  description = "Node where the volume is created";
                  jsonPath = ".spec.ownerNodeID";
                  name = "Node";
                  type = "string";
                }
                {
                  description = "Size of the volume";
                  jsonPath = ".spec.capacity";
                  name = "Size";
                  type = "string";
                }
                {
                  description = "Status of the volume";
                  jsonPath = ".status.state";
                  name = "Status";
                  type = "string";
                }
                {
                  description = "filesystem created on the volume";
                  jsonPath = ".spec.fsType";
                  name = "Filesystem";
                  type = "string";
                }
                {
                  description = "Age of the volume";
                  jsonPath = ".metadata.creationTimestamp";
                  name = "Age";
                  type = "date";
                }
              ];
              name = "v1alpha1";
              schema = {
                openAPIV3Schema = {
                  description = "ZFSVolume represents a ZFS based volume";
                  properties = {
                    apiVersion = {
                      description = "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources";
                      type = "string";
                    };
                    kind = {
                      description = "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds";
                      type = "string";
                    };
                    metadata = {
                      type = "object";
                    };
                    spec = {
                      description = "VolumeInfo defines ZFS volume parameters for all modes in which\nZFS volumes can be created like - ZFS volume with filesystem,\nZFS Volume exposed as zfs or ZFS volume exposed as raw block device.\nSome of the parameters can be only set during creation time\n(as specified in the details of the parameter), and a few are editable.\nIn case of Cloned volumes, the parameters are assigned the same values\nas the source volume.";
                      properties = {
                        capacity = {
                          description = "Capacity of the volume";
                          minLength = 1;
                          type = "string";
                        };
                        compression = {
                          description = "Compression specifies the block-level compression algorithm to be applied to the ZFS Volume.\nThe value \"on\" indicates ZFS to use the default compression algorithm. The default compression\nalgorithm used by ZFS will be either lzjb or, if the lz4_compress feature is enabled, lz4.\nCompression property can be edited after the volume has been created. The change will only\nbe applied to the newly-written data. For instance, if the Volume was created with \"off\" and\nthe next day the compression was modified to \"on\", the data written prior to setting \"on\" will\nnot be compressed.\nDefault Value: off.";
                          pattern = "^(on|off|lzjb|gzip|gzip-[1-9]|zle|lz4)$";
                          type = "string";
                        };
                        dedup = {
                          description = "Deduplication is the process for removing redundant data at the block level,\nreducing the total amount of data stored. If a file system has the dedup property\nenabled, duplicate data blocks are removed synchronously.\nThe result is that only unique data is stored and common components are shared among files.\nDeduplication can consume significant processing power (CPU) and memory as well as generate additional disk IO.\nBefore creating a pool with deduplication enabled, ensure that you have planned your hardware\nrequirements appropriately and implemented appropriate recovery practices, such as regular backups.\nAs an alternative to deduplication consider using compression=lz4, as a less resource-intensive alternative.\nshould be enabled on the zvol.\nDedup property can be edited after the volume has been created.\nDefault Value: off.";
                          enum = [
                            "on"
                            "off"
                          ];
                          type = "string";
                        };
                        encryption = {
                          description = "Enabling the encryption feature allows for the creation of\nencrypted filesystems and volumes. ZFS will encrypt file and zvol data,\nfile attributes, ACLs, permission bits, directory listings, FUID mappings,\nand userused / groupused data. ZFS will not encrypt metadata related to the\npool structure, including dataset and snapshot names, dataset hierarchy,\nproperties, file size, file holes, and deduplication tables\n(though the deduplicated data itself is encrypted).\nDefault Value: off.";
                          pattern = "^(on|off|aes-128-[c,g]cm|aes-192-[c,g]cm|aes-256-[c,g]cm)$";
                          type = "string";
                        };
                        fsType = {
                          description = "FsType specifies filesystem type for the zfs volume/dataset.\nIf FsType is provided as \"zfs\", then the driver will create a\nZFS dataset, formatting is not required as underlying filesystem is ZFS anyway.\nIf FsType is ext2, ext3, ext4 or xfs, then the driver will create a ZVOL and\nformat the volume accordingly.\nFsType can not be modified once volume has been provisioned.\nDefault Value: ext4.";
                          type = "string";
                        };
                        keyformat = {
                          description = "KeyFormat specifies format of the encryption key\nThe supported KeyFormats are passphrase, raw, hex.";
                          enum = [
                            "passphrase"
                            "raw"
                            "hex"
                          ];
                          type = "string";
                        };
                        keylocation = {
                          description = "KeyLocation is the location of key for the encryption";
                          type = "string";
                        };
                        ownerNodeID = {
                          description = "OwnerNodeID is the Node ID where the ZPOOL is running which is where\nthe volume has been provisioned.\nOwnerNodeID can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        poolName = {
                          description = "poolName specifies the name of the pool where the volume has been created.\nPoolName can not be edited after the volume has been provisioned.";
                          minLength = 1;
                          type = "string";
                        };
                        recordsize = {
                          description = "Specifies a suggested block size for files in the file system.\nThe size specified must be a power of two greater than or equal to 512 and less than or equal to 128 Kbytes.\nRecordSize property can be edited after the volume has been created.\nChanging the file system's recordsize affects only files created afterward; existing files are unaffected.\nDefault Value: 128k.";
                          minLength = 1;
                          type = "string";
                        };
                        snapname = {
                          description = "SnapName specifies the name of the snapshot where the volume has been cloned from.\nSnapname can not be edited after the volume has been provisioned.";
                          type = "string";
                        };
                        thinProvision = {
                          description = "ThinProvision describes whether space reservation for the source volume is required or not.\nThe value \"yes\" indicates that volume should be thin provisioned and \"no\" means thick provisioning of the volume.\nIf thinProvision is set to \"yes\" then volume can be provisioned even if the ZPOOL does not\nhave the enough capacity.\nIf thinProvision is set to \"no\" then volume can be provisioned only if the ZPOOL has enough\ncapacity and capacity required by volume can be reserved.\nThinProvision can not be modified once volume has been provisioned.\nDefault Value: no.";
                          enum = [
                            "yes"
                            "no"
                          ];
                          type = "string";
                        };
                        volblocksize = {
                          description = "VolBlockSize specifies the block size for the zvol.\nThe volsize can only be set to a multiple of volblocksize, and cannot be zero.\nVolBlockSize can not be edited after the volume has been provisioned.\nDefault Value: 8k.";
                          minLength = 1;
                          type = "string";
                        };
                        volumeType = {
                          description = "volumeType determines whether the volume is of type \"DATASET\" or \"ZVOL\".\nIf fstype provided in the storageclass is \"zfs\", a volume of type dataset will be created.\nIf \"ext4\", \"ext3\", \"ext2\" or \"xfs\" is mentioned as fstype\nin the storageclass, then a volume of type zvol will be created, which will be\nfurther formatted as the fstype provided in the storageclass.\nVolumeType can not be modified once volume has been provisioned.";
                          enum = [
                            "ZVOL"
                            "DATASET"
                          ];
                          type = "string";
                        };
                      };
                      required = [
                        "capacity"
                        "ownerNodeID"
                        "poolName"
                        "volumeType"
                      ];
                      type = "object";
                    };
                    status = {
                      description = "VolStatus string that specifies the current state of the volume provisioning request.";
                      properties = {
                        state = {
                          description = "State specifies the current state of the volume provisioning request.\nThe state \"Pending\" means that the volume creation request has not\nprocessed yet. The state \"Ready\" means that the volume has been created\nand it is ready for the use.";
                          enum = [
                            "Pending"
                            "Ready"
                          ];
                          type = "string";
                        };
                      };
                      type = "object";
                    };
                  };
                  required = [ "spec" ];
                  type = "object";
                };
              };
              served = true;
              storage = false;
              subresources = { };
            }
          ];
        };
      }
    ];
  };
}
