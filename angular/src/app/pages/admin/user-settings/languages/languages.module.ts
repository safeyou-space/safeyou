import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import {TabsModule} from "ngx-bootstrap/tabs";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../../../../components/shared.module";
import {LanguagesComponent} from "./languages.component";
import {LanguagesRoutingModule} from "./languages-routing.module";
import {ModalModule} from "ngx-bootstrap/modal";
import {PaginationModule} from "ngx-bootstrap/pagination";

@NgModule({
  declarations: [LanguagesComponent],
  imports: [
    CommonModule,
    LanguagesRoutingModule,
    CKEditorModule,
    SharedModule,
    TabsModule.forRoot(),
    AngularMultiSelectModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    PaginationModule,
    FormsModule,
  ]
})
export class LanguagesModule { }
