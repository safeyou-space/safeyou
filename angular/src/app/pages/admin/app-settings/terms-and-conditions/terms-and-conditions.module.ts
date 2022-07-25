import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TermsAndConditionsRoutingModule } from './terms-and-conditions-routing.module';
import { TermsAndConditionsComponent } from './terms-and-conditions.component';
import {SharedModule} from "../../../../components/shared.module";
import {TabsModule} from "ngx-bootstrap/tabs";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    TermsAndConditionsComponent,
  ],
  imports: [
    CommonModule,
    TermsAndConditionsRoutingModule,
    SharedModule,
    TabsModule.forRoot(),
    CKEditorModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class TermsAndConditionsModule { }
