import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TermsOfConsultationRoutingModule } from './terms-of-consultation-routing.module';
import { TermsOfConsultationComponent } from './terms-of-consultation.component';
import {SharedModule} from "../../../../components/shared.module";
import {TabsModule} from "ngx-bootstrap/tabs";
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    TermsOfConsultationComponent
  ],
  imports: [
    CommonModule,
    TermsOfConsultationRoutingModule,
    SharedModule,
    TabsModule.forRoot(),
    CKEditorModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class TermsOfConsultationModule { }
