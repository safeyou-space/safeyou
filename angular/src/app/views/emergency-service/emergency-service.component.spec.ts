import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EmergencyServiceComponent } from './emergency-service.component';

describe('EmergencyServiceComponent', () => {
  let component: EmergencyServiceComponent;
  let fixture: ComponentFixture<EmergencyServiceComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EmergencyServiceComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EmergencyServiceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
