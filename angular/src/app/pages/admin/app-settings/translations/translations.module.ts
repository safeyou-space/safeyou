import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslationsRoutingModule } from './translations-routing.module';
import { TranslationsComponent } from './translations.component';
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import { TranslationsEditCreateComponent } from './translations-edit-create/translations-edit-create.component';
import {ModalModule} from "ngx-bootstrap/modal";
import {PaginationModule} from "ngx-bootstrap/pagination";
import {SharedModule} from "../../../../components/shared.module";
import { TranslationsViewComponent } from './translations-view/translations-view.component';


@NgModule({
  declarations: [
    TranslationsComponent,
    TranslationsEditCreateComponent,
    TranslationsViewComponent
  ],
  imports: [
    CommonModule,
    TranslationsRoutingModule,
    SharedModule,
    TooltipModule.forRoot(),
    ModalModule.forRoot(),
    PaginationModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class TranslationsModule { }
