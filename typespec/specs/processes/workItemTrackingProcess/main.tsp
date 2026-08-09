import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "WorkItemTracking" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://dev.azure.com")
namespace WorkItemTracking;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Class that describes a request to add a field in a work item type. */
model AddProcessWorkItemTypeFieldRequest {
  /** The list of field allowed values. */
  allowedValues?: string[];

  /** Allow setting field value to a group identity. Only applies to identity fields. */
  allowGroups?: boolean;

  /** The default value of the field. */
  defaultValue?: {};

  /** If true the field cannot be edited. */
  readOnly?: boolean;

  /** Reference name of the field. */
  referenceName?: string;

  /** If true the field cannot be empty. */
  required?: boolean;
}

/** Represent a control in the form. */
model Control {
  contribution?: WitContribution;

  /** Type of the control. */
  controlType?: string;

  /** Height of the control, for html controls. */
  height?: int32;

  /** The id for the layout node. */
  id?: string;

  /** A value indicating whether this layout node has been inherited. from a parent layout. This is expected to only be only set by the combiner. */
  inherited?: boolean;

  /** A value indicating if the layout node is contribution or not. */
  isContribution?: boolean;

  /** Label for the field. */
  label?: string;

  /** Inner text of the control. */
  metadata?: string;

  /** Order in which the control should appear in its group. */
  order?: int32;

  /** A value indicating whether this layout node has been overridden . by a child layout. */
  overridden?: boolean;

  /** A value indicating if the control is readonly. */
  readOnly?: boolean;

  /** A value indicating if the control should be hidden or not. */
  visible?: boolean;

  /** Watermark text for the textbox. */
  watermark?: string;
}

/** Describes a process being created. */
model CreateProcessModel {
  /** Description of the process */
  description?: string;

  /** Name of the process */
  name?: string;

  /** The ID of the parent process */
  @format("uuid") parentProcessTypeId?: string;

  /** Reference name of process being created. If not specified, server will assign a unique reference name */
  referenceName?: string;
}

/** Request object/class for creating a rule on a work item type. */
model CreateProcessRuleRequest {
  /** List of actions to take when the rule is triggered. */
  actions?: RuleAction[];

  /** List of conditions when the rule should be triggered. */
  conditions?: RuleCondition[];

  /** Indicates if the rule is disabled. */
  isDisabled?: boolean;

  /** Name for the rule. */
  name?: string;
}

/** Class for create work item type request */
model CreateProcessWorkItemTypeRequest {
  /** Color hexadecimal code to represent the work item type */
  color?: string;

  /** Description of the work item type */
  description?: string;

  /** Icon to represent the work item type */
  icon?: string;

  /** Parent work item type for work item type */
  inheritsFrom?: string;

  /** True if the work item type need to be disabled */
  isDisabled?: boolean;

  /** Name of work item type */
  name?: string;
}

/** Represents the extensions part of the layout */
model Extension {
  /** Id of the extension */
  id?: string;
}

model FieldModel {
  description?: string;
  id?: string;
  isIdentity?: boolean;
  isLocked?: boolean;
  name?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "FieldType",
      values: #[
        #{ value: "string", description: "String field type." },
        #{ value: "integer", description: "Integer field type." },
        #{ value: "dateTime", description: "DateTime field type." },
        #{ value: "plainText", description: "Plain text field type." },
        #{ value: "html", description: "HTML (Multiline) field type." },
        #{ value: "treePath", description: "Treepath field type." },
        #{ value: "history", description: "History field type." },
        #{ value: "double", description: "Double field type." },
        #{ value: "guid", description: "Guid field type." },
        #{ value: "boolean", description: "Boolean field type." },
        #{ value: "identity", description: "Identity field type." },
        #{ value: "picklistInteger", description: "Integer picklist field type." },
        #{ value: "picklistString", description: "String picklist field type." },
        #{ value: "picklistDouble", description: "Double picklist field type." }
      ],
    }
  )
  type?:
    | "string"
    | "integer"
    | "dateTime"
    | "plainText"
    | "html"
    | "treePath"
    | "history"
    | "double"
    | "guid"
    | "boolean"
    | "identity"
    | "picklistInteger"
    | "picklistString"
    | "picklistDouble";
  url?: string;
}

model FieldRuleModel {
  actions?: RuleActionModel[];
  conditions?: RuleConditionModel[];
  friendlyName?: string;
  @format("uuid") id?: string;
  isDisabled?: boolean;
  isSystem?: boolean;
}

/** Describes the layout of a work item type */
model FormLayout {
  /** Gets and sets extensions list. */
  extensions?: Extension[];

  /** Top level tabs of the layout. */
  pages?: Page[];

  /** Headers controls of the layout. */
  systemControls?: Control[];
}

/** Represent a group in the form that holds controls in it. */
model Group {
  contribution?: WitContribution;

  /** Controls to be put in the group. */
  controls?: Control[];

  /** The height for the contribution. */
  height?: int32;

  /** The id for the layout node. */
  id?: string;

  /** A value indicating whether this layout node has been inherited from a parent layout. This is expected to only be only set by the combiner. */
  inherited?: boolean;

  /** A value indicating if the layout node is contribution are not. */
  isContribution?: boolean;

  /** Label for the group. */
  label?: string;

  /** Order in which the group should appear in the section. */
  order?: int32;

  /** A value indicating whether this layout node has been overridden by a child layout. */
  overridden?: boolean;

  /** A value indicating if the group should be hidden or not. */
  visible?: boolean;
}

/** Class that describes the work item state is hidden. */
model HideStateModel {
  /** Returns 'true', if workitem state is hidden, 'false' otherwise. */
  hidden?: boolean;
}

/** Describes a page in the work item form layout */
model Page {
  contribution?: WitContribution;

  /** The id for the layout node. */
  id?: string;

  /** A value indicating whether this layout node has been inherited from a parent layout. This is expected to only be only set by the combiner. */
  inherited?: boolean;

  /** A value indicating if the layout node is contribution are not. */
  isContribution?: boolean;

  /** The label for the page. */
  label?: string;

  /** A value indicating whether any user operations are permitted on this page and the contents of this page */
  locked?: boolean;

  /** Order in which the page should appear in the layout. */
  order?: int32;

  /** A value indicating whether this layout node has been overridden by a child layout. */
  overridden?: boolean;

  /** The icon for the page. */
  @extension(
    "x-ms-enum",
    #{
      name: "PageType",
      values: #[
        #{ value: "custom", description: "Custom page type." },
        #{ value: "history", description: "History page type." },
        #{ value: "links", description: "Link page type." },
        #{ value: "attachments", description: "Attachment page type." }
      ],
    }
  )
  pageType?: "custom" | "history" | "links" | "attachments";

  /** The sections of the page. */
  sections?: Section[];

  /** A value indicating if the page should be hidden or not. */
  visible?: boolean;
}

/** Picklist. */
model PickList {
  ...PickListMetadata;

  /** A list of PicklistItemModel. */
  items?: string[];
}

/** Metadata for picklist. */
model PickListMetadata {
  /** ID of the picklist */
  @format("uuid") id?: string;

  /** Indicates whether items outside of suggested list are allowed */
  isSuggested?: boolean;

  /** Name of the picklist */
  name?: string;

  /** DataType of picklist */
  type?: string;

  /** Url of the picklist */
  url?: string;
}

/** Process Behavior Model. */
model ProcessBehavior {
  /** Color. */
  color?: string;

  /** Indicates the type of customization on this work item. System behaviors are inherited from parent process but not modified. Inherited behaviors are modified behaviors that were inherited from parent process. Custom behaviors are behaviors created by user in current process. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customization?: "system" | "inherited" | "custom";

  /** . Description */
  description?: string;

  /** Process Behavior Fields. */
  fields?: ProcessBehaviorField[];

  inherits?: ProcessBehaviorReference;

  /** Behavior Name. */
  name?: string;

  /** Rank of the behavior */
  rank?: int32;

  /** Behavior Id */
  referenceName?: string;

  /** Url of the behavior. */
  url?: string;
}

/** Process Behavior Create Payload. */
model ProcessBehaviorCreateRequest {
  /** Color. */
  color?: string;

  /** Parent behavior id. */
  inherits?: string;

  /** Name of the behavior. */
  name?: string;

  /** ReferenceName is optional, if not specified will be auto-generated. */
  referenceName?: string;
}

/** Process Behavior Field. */
model ProcessBehaviorField {
  /** Name of the field. */
  name?: string;

  /** Reference name of the field. */
  referenceName?: string;

  /** Url to field. */
  url?: string;
}

/** Process behavior Reference. */
model ProcessBehaviorReference {
  /** Id of a Behavior. */
  behaviorRefName?: string;

  /** Url to behavior. */
  url?: string;
}

/** Process Behavior Replace Payload. */
model ProcessBehaviorUpdateRequest {
  /** Color. */
  color?: string;

  /** Behavior Name. */
  name?: string;
}

/** Process. */
model ProcessInfo {
  /** Indicates the type of customization on this process. System Process is default process. Inherited Process is modified process that was System process before. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customizationType?: "system" | "inherited" | "custom";

  /** Description of the process. */
  description?: string;

  /** Is the process default. */
  isDefault?: boolean;

  /** Is the process enabled. */
  isEnabled?: boolean;

  /** Name of the process. */
  name?: string;

  /** ID of the parent process. */
  @format("uuid") parentProcessTypeId?: string;

  /** Projects in this process to which the user is subscribed to. */
  projects?: ProjectReference[];

  /** Reference name of the process. */
  referenceName?: string;

  /** The ID of the process. */
  @format("uuid") typeId?: string;
}

model ProcessModel {
  /** Description of the process */
  description?: string;

  /** Name of the process */
  name?: string;

  /** Projects in this process */
  projects?: ProjectReference[];

  properties?: ProcessProperties;

  /** Reference name of the process */
  referenceName?: string;

  /** The ID of the process */
  @format("uuid") typeId?: string;
}

/** Properties of the process. */
model ProcessProperties {
  /** Class of the process. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProcessClass",
      values: #[
        #{ value: "system", description: "" },
        #{ value: "derived", description: "" },
        #{ value: "custom", description: "" }
      ],
    }
  )
  class?: "system" | "derived" | "custom";

  /** Is the process default process. */
  isDefault?: boolean;

  /** Is the process enabled. */
  isEnabled?: boolean;

  /** ID of the parent process. */
  @format("uuid") parentProcessTypeId?: string;

  /** Version of the process. */
  version?: string;
}

/** Process Rule Response. */
model ProcessRule {
  ...CreateProcessRuleRequest;

  /** Indicates if the rule is system generated or created by user. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customizationType?: "system" | "inherited" | "custom";

  /** Id to uniquely identify the rule. */
  @format("uuid") id?: string;

  /** Resource Url. */
  url?: string;
}

/** Class that describes a work item type object */
model ProcessWorkItemType {
  behaviors?: WorkItemTypeBehavior[];

  /** Color hexadecimal code to represent the work item type */
  color?: string;

  /** Indicates the type of customization on this work item System work item types are inherited from parent process but not modified Inherited work item types are modified work item that were inherited from parent process Custom work item types are work item types that were created in the current process */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customization?: "system" | "inherited" | "custom";

  /** Description of the work item type */
  description?: string;

  /** Icon to represent the work item typ */
  icon?: string;

  /** Reference name of the parent work item type */
  inherits?: string;

  /** Indicates if a work item type is disabled */
  isDisabled?: boolean;

  layout?: FormLayout;

  /** Name of the work item type */
  name?: string;

  /** Reference name of work item type */
  referenceName?: string;

  states?: WorkItemStateResultModel[];

  /** Url of the work item type */
  url?: string;
}

/** Class that describes a field in a work item type and its properties. */
model ProcessWorkItemTypeField {
  /** The list of field allowed values. */
  allowedValues?: {}[];

  /** Allow setting field value to a group identity. Only applies to identity fields. */
  allowGroups?: boolean;

  /** Indicates the type of customization on this work item. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customization?: "system" | "inherited" | "custom";

  /** The default value of the field. */
  defaultValue?: {};

  /** Description of the field. */
  description?: string;

  /** Information about field definition being locked for editing */
  isLocked?: boolean;

  /** Name of the field. */
  name?: string;

  /** If true the field cannot be edited. */
  readOnly?: boolean;

  /** Reference name of the field. */
  referenceName?: string;

  /** If true the field cannot be empty. */
  required?: boolean;

  /** Type of the field. */
  @extension(
    "x-ms-enum",
    #{
      name: "FieldType",
      values: #[
        #{ value: "string", description: "String field type." },
        #{ value: "integer", description: "Integer field type." },
        #{ value: "dateTime", description: "DateTime field type." },
        #{ value: "plainText", description: "Plain text field type." },
        #{ value: "html", description: "HTML (Multiline) field type." },
        #{ value: "treePath", description: "Treepath field type." },
        #{ value: "history", description: "History field type." },
        #{ value: "double", description: "Double field type." },
        #{ value: "guid", description: "Guid field type." },
        #{ value: "boolean", description: "Boolean field type." },
        #{ value: "identity", description: "Identity field type." },
        #{ value: "picklistInteger", description: "Integer picklist field type." },
        #{ value: "picklistString", description: "String picklist field type." },
        #{ value: "picklistDouble", description: "Double picklist field type." }
      ],
    }
  )
  type?:
    | "string"
    | "integer"
    | "dateTime"
    | "plainText"
    | "html"
    | "treePath"
    | "history"
    | "double"
    | "guid"
    | "boolean"
    | "identity"
    | "picklistInteger"
    | "picklistString"
    | "picklistDouble";

  /** Resource URL of the field. */
  url?: string;
}

/** Defines the project reference class. */
model ProjectReference {
  /** Description of the project */
  description?: string;

  /** The ID of the project */
  @format("uuid") id?: string;

  /** Name of the project */
  name?: string;

  /** Url of the project */
  url?: string;
}

/** Action to take when the rule is triggered. */
model RuleAction {
  /** Type of action to take when the rule is triggered. */
  @extension(
    "x-ms-enum",
    #{
      name: "RuleActionType",
      values: #[
        #{
          value: "makeRequired",
          description: "Make the target field required. Example : {'actionType':'$makeRequired','targetField':'Microsoft.VSTS.Common.Activity','value':''}",
        },
        #{
          value: "makeReadOnly",
          description: "Make the target field read-only. Example : {'actionType':'$makeReadOnly','targetField':'Microsoft.VSTS.Common.Activity','value':''}",
        },
        #{
          value: "setDefaultValue",
          description: "Set a default value on the target field. This is used if the user creates a integer/string field and sets a default value of this field.",
        },
        #{
          value: "setDefaultFromClock",
          description: "Set the default value on the target field from server clock. This is used if user creates the field like Date/Time and uses default value.",
        },
        #{
          value: "setDefaultFromCurrentUser",
          description: "Set the default current user value on the target field. This is used if the user creates the field of type identity and uses default value.",
        },
        #{
          value: "setDefaultFromField",
          description: "Set the default value on from existing field to the target field. This used wants to set a existing field value to the current field.",
        },
        #{
          value: "copyValue",
          description: "Set the value of target field to given value. Example : {actionType: '$copyValue', targetField: 'ScrumInherited.mypicklist', value: 'samplevalue'}",
        },
        #{ value: "copyFromClock", description: "Set the value from clock." },
        #{
          value: "copyFromCurrentUser",
          description: "Set the current user to the target field. Example : {'actionType':'$copyFromCurrentUser','targetField':'System.AssignedTo','value':''}.",
        },
        #{
          value: "copyFromField",
          description: "Copy the value from a specified field and set to target field. Example : {actionType: '$copyFromField', targetField: 'System.AssignedTo', value:'System.ChangedBy'}. Here, value is copied from 'System.ChangedBy' and set to 'System.AssingedTo' field.",
        },
        #{ value: "setValueToEmpty", description: "Set the value of the target field to empty." },
        #{
          value: "copyFromServerClock",
          description: "Use the current time to set the value of the target field. Example : {actionType: '$copyFromServerClock', targetField: 'System.CreatedDate', value: ''}",
        },
        #{
          value: "copyFromServerCurrentUser",
          description: "Use the current user to set the value of the target field.",
        },
        #{
          value: "hideTargetField",
          description: "Hides target field from the form. This is a server side only action.",
        },
        #{
          value: "disallowValue",
          description: "Disallows a field from being set to a specific value.",
        }
      ],
    }
  )
  actionType?:
    | "makeRequired"
    | "makeReadOnly"
    | "setDefaultValue"
    | "setDefaultFromClock"
    | "setDefaultFromCurrentUser"
    | "setDefaultFromField"
    | "copyValue"
    | "copyFromClock"
    | "copyFromCurrentUser"
    | "copyFromField"
    | "setValueToEmpty"
    | "copyFromServerClock"
    | "copyFromServerCurrentUser"
    | "hideTargetField"
    | "disallowValue";

  /** Field on which the action should be taken. */
  targetField?: string;

  /** Value to apply on target field, once the action is taken. */
  value?: string;
}

/** Action to take when the rule is triggered. */
model RuleActionModel {
  actionType?: string;
  targetField?: string;
  value?: string;
}

/** Defines a condition on a field when the rule should be triggered. */
model RuleCondition {
  /** Type of condition. $When. This condition limits the execution of its children to cases when another field has a particular value, i.e. when the Is value of the referenced field is equal to the given literal value. $WhenNot.This condition limits the execution of its children to cases when another field does not have a particular value, i.e.when the Is value of the referenced field is not equal to the given literal value. $WhenChanged.This condition limits the execution of its children to cases when another field has changed, i.e.when the Is value of the referenced field is not equal to the Was value of that field. $WhenNotChanged.This condition limits the execution of its children to cases when another field has not changed, i.e.when the Is value of the referenced field is equal to the Was value of that field. */
  @extension(
    "x-ms-enum",
    #{
      name: "RuleConditionType",
      values: #[
        #{
          value: "when",
          description: "$When. This condition limits the execution of its children to cases when another field has a particular value, i.e. when the Is value of the referenced field is equal to the given literal value.",
        },
        #{
          value: "whenNot",
          description: "$WhenNot.This condition limits the execution of its children to cases when another field does not have a particular value, i.e.when the Is value of the referenced field is not equal to the given literal value.",
        },
        #{
          value: "whenChanged",
          description: "$WhenChanged.This condition limits the execution of its children to cases when another field has changed, i.e.when the Is value of the referenced field is not equal to the Was value of that field.",
        },
        #{
          value: "whenNotChanged",
          description: "$WhenNotChanged.This condition limits the execution of its children to cases when another field has not changed, i.e.when the Is value of the referenced field is equal to the Was value of that field.",
        },
        #{
          value: "whenWas",
          description: "$WhenWas. This condition limits the execution of its children to cases when another field value is changed from one value to another. e.g. If the condition is : When the work item state changes from New to Approved, here $WhenWas clause defines the 'New' state of the workitem and $When clause defines 'Approved' state.",
        },
        #{ value: "whenStateChangedTo", description: "" },
        #{ value: "whenStateChangedFromAndTo", description: "" },
        #{ value: "whenWorkItemIsCreated", description: "" },
        #{ value: "whenValueIsDefined", description: "" },
        #{ value: "whenValueIsNotDefined", description: "" },
        #{
          value: "whenCurrentUserIsMemberOfGroup",
          description: "This condition checks if current user is member of a particular group. This condition does not have any 1:1 mapping with any server side rule condition, rather this is a dummy condition added for customer simplicity of understanding. This condition is later translated to a FOR membership filter . e.g. If the condition is : WhenCurrentUserIsMemberOfGroup 'Approvers' then 'MakeRequired' Field1.Here it translates to a For rule , 'MakeRequired' for 'Approvers'",
        },
        #{
          value: "whenCurrentUserIsNotMemberOfGroup",
          description: "This condition checks if current user is not member of a particular group. This condition does not have any 1:1 mapping with any server side rule condition, rather this is a dummy condition added for customer simplicity of understanding. This condition is later translated to a NOT membership filter . e.g. If the condition is : WhenCurrentUserIsNotMemberOfGroup 'Approvers' then 'MakeRequired' Field1.Here it translates to a Not rule , 'MakeRequired' not 'Approvers'",
        }
      ],
    }
  )
  conditionType?:
    | "when"
    | "whenNot"
    | "whenChanged"
    | "whenNotChanged"
    | "whenWas"
    | "whenStateChangedTo"
    | "whenStateChangedFromAndTo"
    | "whenWorkItemIsCreated"
    | "whenValueIsDefined"
    | "whenValueIsNotDefined"
    | "whenCurrentUserIsMemberOfGroup"
    | "whenCurrentUserIsNotMemberOfGroup";

  /** Field that defines condition. */
  field?: string;

  /** Value of field to define the condition for rule. */
  value?: string;
}

model RuleConditionModel {
  conditionType?: string;
  field?: string;
  value?: string;
}

/** Defines a section of the work item form layout */
model Section {
  /** List of child groups in this section */
  groups?: Group[];

  /** The id for the layout node. */
  id?: string;

  /** A value indicating whether this layout node has been overridden by a child layout. */
  overridden?: boolean;
}

/** Describes a request to update a process */
model UpdateProcessModel {
  /** New description of the process */
  description?: string;

  /** If true new projects will use this process by default */
  isDefault?: boolean;

  /** If false the process will be disabled and cannot be used to create projects */
  isEnabled?: boolean;

  /** New name of the process */
  name?: string;
}

/** Request class/object to update the rule. */
model UpdateProcessRuleRequest {
  ...CreateProcessRuleRequest;

  /** Id to uniquely identify the rule. */
  @format("uuid") id?: string;
}

/** Class to describe a request that updates a field's properties in a work item type. */
model UpdateProcessWorkItemTypeFieldRequest {
  /** The list of field allowed values. */
  allowedValues?: string[];

  /** Allow setting field value to a group identity. Only applies to identity fields. */
  allowGroups?: boolean;

  /** The default value of the field. */
  defaultValue?: {};

  /** If true the field cannot be edited. */
  readOnly?: boolean;

  /** The default value of the field. */
  required?: boolean;
}

/** Class for update request on a work item type */
model UpdateProcessWorkItemTypeRequest {
  /** Color of the work item type */
  color?: string;

  /** Description of the work item type */
  description?: string;

  /** Icon of the work item type */
  icon?: string;

  /** If set will disable the work item type */
  isDisabled?: boolean;
}

/** This class is used to serialize collections as a single JSON object on the wire. */
model VssJsonCollectionWrapper {
  ...VssJsonCollectionWrapperBase;

  /** The serialized item. */
  @format("T") value?: string;
}

model VssJsonCollectionWrapperBase {
  /** The number of serialized items. */
  count?: int32;
}

/** Properties of a work item form contribution */
model WitContribution {
  /** The id for the contribution. */
  contributionId?: string;

  /** The height for the contribution. */
  height?: int32;

  /** A dictionary holding key value pairs for contribution inputs. */
  inputs?: Record<{}>;

  /** A value indicating if the contribution should be show on deleted workItem. */
  showOnDeletedWorkItem?: boolean;
}

model WorkItemBehavior {
  abstract?: boolean;
  color?: string;
  description?: string;
  fields?: WorkItemBehaviorField[];
  id?: string;
  inherits?: WorkItemBehaviorReference;
  name?: string;
  overriden?: boolean;
  rank?: int32;
  url?: string;
}

model WorkItemBehaviorField {
  behaviorFieldId?: string;
  id?: string;
  url?: string;
}

/** Reference to the behavior of a work item type. */
model WorkItemBehaviorReference {
  /** The ID of the reference behavior. */
  id?: string;

  /** The url of the reference behavior. */
  url?: string;
}

/** Class That represents a work item state input. */
model WorkItemStateInputModel {
  /** Color of the state */
  color?: string;

  /** Name of the state */
  name?: string;

  /** Order in which state should appear */
  order?: int32;

  /** Category of the state */
  stateCategory?: string;
}

/** Class that represents a work item state result. */
model WorkItemStateResultModel {
  /** Work item state color. */
  color?: string;

  /** Work item state customization type. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomizationType",
      values: #[
        #{
          value: "system",
          description: "Customization-type is System if is system generated workitemtype.",
        },
        #{
          value: "inherited",
          description: "Customization-type is Inherited if the existing workitemtype of inherited process is customized.",
        },
        #{
          value: "custom",
          description: "Customization-type is Custom if the newly created workitemtype is customized.",
        }
      ],
    }
  )
  customizationType?: "system" | "inherited" | "custom";

  /** If the Work item state is hidden. */
  hidden?: boolean;

  /** Id of the Workitemstate. */
  @format("uuid") id?: string;

  /** Work item state name. */
  name?: string;

  /** Work item state order. */
  order?: int32;

  /** Work item state statecategory. */
  stateCategory?: string;

  /** Work item state url. */
  url?: string;
}

/** Association between a work item type and it's behavior */
model WorkItemTypeBehavior {
  behavior?: WorkItemBehaviorReference;

  /** If true the work item type is the default work item type in the behavior */
  isDefault?: boolean;

  /** If true the work item type is the default work item type in the parent behavior */
  isLegacyDefault?: boolean;

  /** URL of the work item type behavior */
  url?: string;
}

model WorkItemTypeModel {
  behaviors?: WorkItemTypeBehavior[];
  @extension(
    "x-ms-enum",
    #{
      name: "WorkItemTypeClass",
      values: #[
        #{ value: "system", description: "" },
        #{ value: "derived", description: "" },
        #{ value: "custom", description: "" }
      ],
    }
  )
  class?: "system" | "derived" | "custom";
  color?: string;
  description?: string;
  icon?: string;
  id?: string;

  /** Parent WIT Id/Internal ReferenceName that it inherits from */
  inherits?: string;

  isDisabled?: boolean;
  layout?: FormLayout;
  name?: string;
  states?: WorkItemStateResultModel[];
  url?: string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Processes {
  /** Get list of all processes including system and inherited. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "GetListOfProcesses")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @extension(
      "x-ms-enum",
      #{
        name: "GetProcessExpandLevel",
        values: #[
          #{ value: "none", description: "No expand level." },
          #{ value: "projects", description: "Projects expand level." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "projects",
    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ProcessInfo[]>;

  /** Creates a process. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "CreateNewProcess")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** CreateProcessModel. */
    @body body: CreateProcessModel,
  ): ProcessInfo;

  /** Removes a process of a specific ID. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "DeleteProcessById")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processTypeId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @format("uuid") @path processTypeId: string,
    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Get a single process of a specified ID. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "GetProcessByItsId")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processTypeId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @format("uuid") @path processTypeId: string,
    @extension(
      "x-ms-enum",
      #{
        name: "GetProcessExpandLevel",
        values: #[
          #{ value: "none", description: "No expand level." },
          #{ value: "projects", description: "Projects expand level." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "projects",
    ...Parameters.`api-Version-preview`.`2`,
  ): ProcessInfo;

  /** Edit a process of a specific ID. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "EditProcess")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processTypeId}")
  @patch
  EditProcess(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @format("uuid") @path processTypeId: string,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: UpdateProcessModel,
  ): ProcessInfo;
}

interface Behaviors {
  /** Returns a list of all behaviors in the process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "GetProcessBehaviors")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/behaviors")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    @extension(
      "x-ms-enum",
      #{
        name: "GetBehaviorsExpand",
        values: #[
          #{ value: "none", description: "Default none option." },
          #{
            value: "fields",
            description: "This option returns fields associated with a behavior.",
          },
          #{
            value: "combinedFields",
            description: "This option returns fields associated with this behavior and all behaviors from which it inherits.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "fields" | "combinedFields",
    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ProcessBehavior[]>;

  /** Creates a single behavior in the given process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "CreateProcessBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/behaviors")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: ProcessBehaviorCreateRequest,
  ): ProcessBehavior;

  /** Removes a behavior in the process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "DeleteProcessBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/behaviors/{behaviorRefName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the behavior */
    @path behaviorRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Returns a behavior of the process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "GetProcessBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/behaviors/{behaviorRefName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the behavior */
    @path behaviorRefName: string,

    @extension(
      "x-ms-enum",
      #{
        name: "GetBehaviorsExpand",
        values: #[
          #{ value: "none", description: "Default none option." },
          #{
            value: "fields",
            description: "This option returns fields associated with a behavior.",
          },
          #{
            value: "combinedFields",
            description: "This option returns fields associated with this behavior and all behaviors from which it inherits.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "fields" | "combinedFields",
    ...Parameters.`api-Version-preview`.`2`,
  ): ProcessBehavior;

  /** Replaces a behavior in the process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "UpdateProcessBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/behaviors/{behaviorRefName}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the behavior */
    @path behaviorRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: ProcessBehaviorUpdateRequest,
  ): ProcessBehavior;
}

interface WorkItemTypes {
  /** Returns a list of all work item types in a process. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "GetProcessWorkItemTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Flag to determine what properties of work item type to return */
    @extension(
      "x-ms-enum",
      #{
        name: "GetWorkItemTypeExpand",
        values: #[
          #{ value: "none", description: "Returns no properties in get work item type response." },
          #{
            value: "states",
            description: "Returns states property in get work item type response.",
          },
          #{
            value: "behaviors",
            description: "Returns behaviors property in get work item type response.",
          },
          #{ value: "layout", description: "Returns layout property in get work item type response." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "states" | "behaviors" | "layout",

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ProcessWorkItemType[]>;

  /** Creates a work item type in the process. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "CreateProcessWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypes")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process on which to create work item type. */
    @format("uuid") @path processId: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: CreateProcessWorkItemTypeRequest,
  ): ProcessWorkItemType;

  /** Removes a work item type in the process. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "DeleteProcessWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypes/{witRefName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Returns a single work item type in a process. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "GetProcessWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypes/{witRefName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** Flag to determine what properties of work item type to return */
    @extension(
      "x-ms-enum",
      #{
        name: "GetWorkItemTypeExpand",
        values: #[
          #{ value: "none", description: "Returns no properties in get work item type response." },
          #{
            value: "states",
            description: "Returns states property in get work item type response.",
          },
          #{
            value: "behaviors",
            description: "Returns behaviors property in get work item type response.",
          },
          #{ value: "layout", description: "Returns layout property in get work item type response." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "states" | "behaviors" | "layout",

    ...Parameters.`api-Version-preview`.`2`,
  ): ProcessWorkItemType;

  /** Updates a work item type of the process. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "UpdateProcessWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypes/{witRefName}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: UpdateProcessWorkItemTypeRequest,
  ): ProcessWorkItemType;
}

interface Fields {
  /** Returns a list of all fields in a work item type. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "GetAllWorkItemTypeFields")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/fields")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ProcessWorkItemTypeField[]>;

  /** Adds a field to a work item type. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "AddFieldToWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/fields")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: AddProcessWorkItemTypeFieldRequest,
  ): ProcessWorkItemTypeField;

  /** Removes a field from a work item type. Does not permanently delete the field. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "RemoveWorkItemTypeField")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/fields/{fieldRefName}")
  @delete
  RemoveWorkItemTypeField(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The reference name of the field. */
    @path fieldRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Returns a field in a work item type. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "GetWorkItemTypeField")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/fields/{fieldRefName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The reference name of the field. */
    @path fieldRefName: string,

    @extension(
      "x-ms-enum",
      #{
        name: "ProcessWorkItemTypeFieldsExpandLevel",
        values: #[
          #{ value: "none", description: "Includes only basic properties of the field." },
          #{ value: "allowedValues", description: "Includes allowed values for the field." },
          #{ value: "all", description: "Includes allowed values and dependent fields of the field." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "allowedValues" | "all",
    ...Parameters.`api-Version-preview`.`2`,
  ): ProcessWorkItemTypeField;

  /** Updates a field in a work item type. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "UpdateWorkItemTypeField")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/fields/{fieldRefName}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The reference name of the field. */
    @path fieldRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: UpdateProcessWorkItemTypeFieldRequest,
  ): ProcessWorkItemTypeField;
}

interface Layout {
  /** Gets the form layout. */
  @tag("Layout")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "layout")
  @extension("x-ms-vss-method", "GetFormLayout")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FormLayout;
}

interface Controls {
  /** Creates a control in a group. */
  @tag("Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "controls")
  @extension("x-ms-vss-method", "CreateControlInGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/groups/{groupId}/controls")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the group to add the control to. */
    @path groupId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The control. */
    @body body: Control,
  ): Control;

  /** Removes a control from the work item form. */
  @tag("Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "controls")
  @extension("x-ms-vss-method", "RemoveControlFromGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/groups/{groupId}/controls/{controlId}")
  @delete
  RemoveControlFromGroup(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the group. */
    @path groupId: string,

    /** The ID of the control to remove. */
    @path controlId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Updates a control on the work item form. */
  @tag("Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "controls")
  @extension("x-ms-vss-method", "UpdateControl")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/groups/{groupId}/controls/{controlId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the group. */
    @path groupId: string,

    /** The ID of the control. */
    @path controlId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The updated control. */
    @body body: Control,
  ): Control;

  /** Moves a control to a specified group. */
  @tag("Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "controls")
  @extension("x-ms-vss-method", "MoveControlToGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/groups/{groupId}/controls/{controlId}")
  @put
  MoveControlToGroup(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the group to move the control to. */
    @path groupId: string,

    /** The ID of the control. */
    @path controlId: string,

    /** The group ID to remove the control from. */
    @query(#{ explode: true }) removeFromGroupId?: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The control. */
    @body body: Control,
  ): Control;
}

interface Pages {
  /** Updates a page on the work item form */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "UpdatePage")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The page */
    @body body: Page,
  ): Page;

  /** Adds a page to the work item form. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "AddPage")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The page. */
    @body body: Page,
  ): Page;

  /** Removes a page from the work item form */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "RemovePage")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages/{pageId}")
  @delete
  RemovePage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the page */
    @path pageId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface Groups {
  /** Adds a group to the work item form. */
  @tag("Groups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groups")
  @extension("x-ms-vss-method", "AddGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages/{pageId}/sections/{sectionId}/groups")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the page to add the group to. */
    @path pageId: string,

    /** The ID of the section to add the group to. */
    @path sectionId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The group. */
    @body body: Group,
  ): Group;

  /** Removes a group from the work item form. */
  @tag("Groups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groups")
  @extension("x-ms-vss-method", "RemoveGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages/{pageId}/sections/{sectionId}/groups/{groupId}")
  @delete
  RemoveGroup(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the page the group is in */
    @path pageId: string,

    /** The ID of the section to the group is in */
    @path sectionId: string,

    /** The ID of the group */
    @path groupId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Updates a group in the work item form. */
  @tag("Groups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groups")
  @extension("x-ms-vss-method", "UpdateGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages/{pageId}/sections/{sectionId}/groups/{groupId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the page the group is in. */
    @path pageId: string,

    /** The ID of the section the group is in. */
    @path sectionId: string,

    /** The ID of the group. */
    @path groupId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The updated group. */
    @body body: Group,
  ): Group;

  /** Moves a group to a different section. */
  @tag("Groups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groups")
  @extension("x-ms-vss-method", "MoveGroupToSection")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/pages/{pageId}/sections/{sectionId}/groups/{groupId}")
  @put
  MoveGroupToSection(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the page the group is in. */
    @path pageId: string,

    /** The ID of the section the group is in. */
    @path sectionId: string,

    /** The ID of the group. */
    @path groupId: string,

    /** ID of the section to remove the group from. */
    @query(#{ explode: true }) removeFromSectionId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The updated group. */
    @body body: Group,
  ): Group;
}

interface SystemControls {
  /** Gets edited system controls for a work item type in a process. To get all system controls (base + edited) use layout API(s) */
  @tag("System Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "systemControls")
  @extension("x-ms-vss-method", "GetSystemControls")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/systemcontrols")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Control[]>;

  /** Deletes a system control modification on the work item form. */
  @tag("System Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "systemControls")
  @extension("x-ms-vss-method", "DeleteSystemControl")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/systemcontrols/{controlId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the control. */
    @path controlId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Control[]>;

  /** Updates/adds a system control on the work item form. */
  @tag("System Controls")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "systemControls")
  @extension("x-ms-vss-method", "UpdateSystemControl")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/layout/systemcontrols/{controlId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process. */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type. */
    @path witRefName: string,

    /** The ID of the control. */
    @path controlId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: Control,
  ): Control;
}

interface Rules {
  /** Returns a list of all rules in the work item type of the process. */
  @tag("Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "rules")
  @extension("x-ms-vss-method", "GetProcessWorkItemTypeRules")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/rules")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ProcessRule[]>;

  /** Adds a rule to work item type in the process. */
  @tag("Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "rules")
  @extension("x-ms-vss-method", "AddProcessWorkItemTypeRule")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/rules")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: CreateProcessRuleRequest,
  ): ProcessRule;

  /** Removes a rule from the work item type in the process. */
  @tag("Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "rules")
  @extension("x-ms-vss-method", "DeleteProcessWorkItemTypeRule")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/rules/{ruleId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the rule */
    @format("uuid") @path ruleId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Returns a single rule in the work item type of the process. */
  @tag("Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "rules")
  @extension("x-ms-vss-method", "GetProcessWorkItemTypeRule")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/rules/{ruleId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the rule */
    @format("uuid") @path ruleId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): ProcessRule;

  /** Updates a rule in the work item type of the process. */
  @tag("Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "rules")
  @extension("x-ms-vss-method", "UpdateProcessWorkItemTypeRule")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/rules/{ruleId}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the rule */
    @format("uuid") @path ruleId: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: UpdateProcessRuleRequest,
  ): ProcessRule;
}

interface States {
  /** Returns a list of all state definitions in a work item type of the process. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "GetStateDefinitions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<WorkItemStateResultModel[]>;

  /** Creates a state definition in the work item type of the process. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "CreateStateDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemStateInputModel,
  ): WorkItemStateResultModel;

  /** Removes a state definition in the work item type of the process. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "DeleteStateDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states/{stateId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** ID of the state */
    @format("uuid") @path stateId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a single state definition in a work item type of the process. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "GetStateDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states/{stateId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the state */
    @format("uuid") @path stateId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemStateResultModel;

  /** Updates a given state definition in the work item type of the process. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "UpdateStateDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states/{stateId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** ID of the state */
    @format("uuid") @path stateId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemStateInputModel,
  ): WorkItemStateResultModel;

  /** Hides a state definition in the work item type of the process.Only states with customizationType:System can be hidden. */
  @tag("States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "states")
  @extension("x-ms-vss-method", "HideStateDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workItemTypes/{witRefName}/states/{stateId}")
  @put
  HideStateDefinition(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** The reference name of the work item type */
    @path witRefName: string,

    /** The ID of the state */
    @format("uuid") @path stateId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: HideStateModel,
  ): WorkItemStateResultModel;
}

interface WorkItemTypesBehaviors {
  /** Returns a list of all behaviors for the work item type of the process. */
  @tag("Work Item Types Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypesBehaviors")
  @extension("x-ms-vss-method", "GetBehaviorsForWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{witRefNameForBehaviors}/behaviors")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Work item type reference name for the behavior */
    @path witRefNameForBehaviors: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<WorkItemTypeBehavior[]>;

  /** Updates a behavior for the work item type of the process. */
  @tag("Work Item Types Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypesBehaviors")
  @extension("x-ms-vss-method", "UpdateBehaviorToWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{witRefNameForBehaviors}/behaviors")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Work item type reference name for the behavior */
    @path witRefNameForBehaviors: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemTypeBehavior,
  ): WorkItemTypeBehavior;

  /** Adds a behavior to the work item type of the process. */
  @tag("Work Item Types Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypesBehaviors")
  @extension("x-ms-vss-method", "AddBehaviorToWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{witRefNameForBehaviors}/behaviors")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Work item type reference name for the behavior */
    @path witRefNameForBehaviors: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemTypeBehavior,
  ): WorkItemTypeBehavior;

  /** Removes a behavior for the work item type of the process. */
  @tag("Work Item Types Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypesBehaviors")
  @extension("x-ms-vss-method", "RemoveBehaviorFromWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{witRefNameForBehaviors}/behaviors/{behaviorRefName}")
  @delete
  RemoveBehaviorFromWorkItemType(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Work item type reference name for the behavior */
    @path witRefNameForBehaviors: string,

    /** The reference name of the behavior */
    @path behaviorRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a behavior for the work item type of the process. */
  @tag("Work Item Types Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypesBehaviors")
  @extension("x-ms-vss-method", "GetBehaviorForWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{witRefNameForBehaviors}/behaviors/{behaviorRefName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    /** Work item type reference name for the behavior */
    @path witRefNameForBehaviors: string,

    /** The reference name of the behavior */
    @path behaviorRefName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemTypeBehavior;
}

interface Lists {
  /** Returns meta data of the picklist. */
  @tag("Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "lists")
  @extension("x-ms-vss-method", "GetListsMetadata")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/lists")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<PickListMetadata[]>;

  /** Creates a picklist. */
  @tag("Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "lists")
  @extension("x-ms-vss-method", "CreateList")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/lists")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Picklist */
    @body body: PickList,
  ): PickList;

  /** Removes a picklist. */
  @tag("Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "lists")
  @extension("x-ms-vss-method", "DeleteList")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/lists/{listId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the list */
    @format("uuid") @path listId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a picklist. */
  @tag("Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "lists")
  @extension("x-ms-vss-method", "GetList")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/lists/{listId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the list */
    @format("uuid") @path listId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PickList;

  /** Updates a list. */
  @tag("Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "lists")
  @extension("x-ms-vss-method", "UpdateList")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processes/lists/{listId}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the list */
    @format("uuid") @path listId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PickList,
  ): PickList;
}
