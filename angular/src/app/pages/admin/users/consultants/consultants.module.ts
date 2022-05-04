import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ConsultantsRoutingModule } from './consultants-routing.module';
import { ConsultantsComponent } from './consultants.component';
import { ConsultantsViewComponent } from './consultants-view/consultants-view.component';
import { ConsultantsEditCreateComponent } from './consultants-edit-create/consultants-edit-create.component';
import {TabsModule} from "ngx-bootstrap/tabs";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {SharedModule} from "../../../../components/shared.module";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {ModalModule} from "ngx-bootstrap/modal";
import {AccordionModule} from "ngx-bootstrap/accordion";
import { ConsultantsProfessionComponent } from './consultants-profession/consultants-profession.component';
import {CKEditorModule} from "@ckeditor/ckeditor5-angular";
import { ConsultantsBidsComponent } from './consultants-bids/consultants-bids.component';
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { ConsultantsFilterComponent } from './consultants-filter/consultants-filter.component';

@NgModule({
  declarations: [
    ConsultantsComponent,
    ConsultantsViewComponent,
    ConsultantsEditCreateComponent,
    ConsultantsProfessionComponent,
    ConsultantsBidsComponent,
    ConsultantsFilterComponent
  ],
  imports: [
    CommonModule,
    ConsultantsRoutingModule,
    SharedModule,
    TabsModule.forRoot(),
    BsDropdownModule.forRoot(),
    ModalModule.forRoot(),
    TooltipModule.forRoot(),
    AccordionModule.forRoot(),
    PaginationModule,
    CKEditorModule,
    AngularMultiSelectModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class ConsultantsModule { }
