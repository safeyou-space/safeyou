import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {UserProfileComponent} from "./user-profile.component";
import {UserProfileRoutingModule} from "./user-profile-routing.module";
import {SharedModule} from "../../../../components/shared.module";
import {ModalModule} from "ngx-bootstrap/modal";
import {ReactiveFormsModule} from "@angular/forms";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {AccordionModule} from "ngx-bootstrap/accordion";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";


@NgModule({
  declarations: [UserProfileComponent],
  imports: [
    CommonModule,
    SharedModule,
    UserProfileRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    TooltipModule.forRoot(),
    AccordionModule.forRoot(),
    CKEditorModule,
    AngularMultiSelectModule,
  ]
})
export class UserProfileModule { }
