import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationRoutingModule } from './push-notification-routing.module';
import { PushNotificationComponent } from './push-notification.component';
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {SharedModule} from "../../../../components/shared.module";
import { PushNotificationViewComponent } from './push-notification-view/push-notification-view.component';
import {TabsModule} from "ngx-bootstrap/tabs";
import { PushNotificationEditCreateComponent } from './push-notification-edit-create/push-notification-edit-create.component';
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    PushNotificationComponent,
    PushNotificationViewComponent,
    PushNotificationEditCreateComponent,
  ],
  imports: [
    CommonModule,
    PushNotificationRoutingModule,
    SharedModule,
    TabsModule.forRoot(),
    BsDropdownModule.forRoot(),
    CKEditorModule,
    TooltipModule.forRoot(),
    AngularMultiSelectModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class PushNotificationModule { }
