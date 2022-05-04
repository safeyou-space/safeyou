import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {HeaderComponent} from "./header/header.component";
import {SidebarComponent} from "./sidebar/sidebar.component";
import {RouterModule} from "@angular/router";
import { DateInputComponent } from './forms-components/date-input/date-input.component';
import { FilterComponent } from './utils/filter/filter.component';
import { DateInputRangeComponent } from './forms-components/date-input-range/date-input-range.component';
import { DeleteModalComponent } from './utils/delete-modal/delete-modal.component';
import { ReportModalComponent } from './utils/report-modal/report-modal.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {ModalModule} from "ngx-bootstrap/modal";
import { RateStarsComponent } from './utils/rate-stars/rate-stars.component';
import {InfoModalComponent} from "./utils/info-modal/info-modal.component";
import {MapComponent} from "./utils/map/map.component";
import {DurationPipe} from "../shared/durationPipe/duration.pipe";
import {TrimDirective} from "../shared/Directives/trim.directive";
import { RatingModalComponent } from './utils/rating-modal/rating-modal.component';
import { RatingViewComponent } from './utils/rating-view/rating-view.component';


@NgModule({
  declarations: [
    HeaderComponent,
    SidebarComponent,
    DateInputComponent,
    FilterComponent,
    DateInputRangeComponent,
    DeleteModalComponent,
    ReportModalComponent,
    RateStarsComponent,
    InfoModalComponent,
    MapComponent,
    DurationPipe,
    TrimDirective,
    RatingModalComponent,
    RatingViewComponent
  ],
  exports: [
    HeaderComponent,
    SidebarComponent,
    DateInputComponent,
    FilterComponent,
    DateInputRangeComponent,
    DeleteModalComponent,
    ReportModalComponent,
    RateStarsComponent,
    InfoModalComponent,
    MapComponent,
    DurationPipe,
    TrimDirective,
    RatingModalComponent,
    RatingViewComponent
  ],
  imports: [
    CommonModule,
    RouterModule,
    FormsModule,
    ReactiveFormsModule,
    AngularMultiSelectModule,
    BsDropdownModule.forRoot(),
    ModalModule.forRoot()
  ]
})
export class SharedModule {
}
