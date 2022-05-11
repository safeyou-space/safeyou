import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../../components/shared.module";
import {TabsModule} from "ngx-bootstrap/tabs";
import {BeneficiaryComponent} from "./beneficiary.component";
import {BeneficiaryRoutingModule} from "./beneficiary-routing.module";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {ModalModule} from "ngx-bootstrap/modal";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { BeneficiaryViewComponent } from './beneficiary-view/beneficiary-view.component';
import { LocationPipe } from './location.pipe';


@NgModule({
  declarations: [BeneficiaryComponent, BeneficiaryViewComponent, LocationPipe],
  imports: [
    CommonModule,
    SharedModule,
    BeneficiaryRoutingModule,
    TabsModule.forRoot(),
    ModalModule.forRoot(),
    TooltipModule.forRoot(),
    AngularMultiSelectModule,
    PaginationModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class BeneficiaryModule { }
