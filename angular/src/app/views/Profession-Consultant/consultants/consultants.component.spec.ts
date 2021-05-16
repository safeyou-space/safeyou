import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ConsultantsComponent } from './consultants.component';

describe('ConsultantsComponent', () => {
  let component: ConsultantsComponent;
  let fixture: ComponentFixture<ConsultantsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ConsultantsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConsultantsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
