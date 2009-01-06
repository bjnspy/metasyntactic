//
//  Decision.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Decision.h"

@interface Decision()
@property NSInteger year;
@property Category category;
@property (retain) NSString* title;
@property (retain) NSString* synopsis;
@property (retain) NSString* link;
@end

@implementation Decision

static NSArray* greatestHits;

+ (void) initialize {
    if (self == [Decision class]) {
        greatestHits = 
        [[NSArray arrayWithObjects:
          [Decision decisionWithYear:1925 category:FreedomOfExpression title:@"Gitlow v. New York" synopsis:
           NSLocalizedString(@"Gitlow’s conviction for distributing a pamphlet calling for the overthrow "
                             @"of the government was upheld. But the ACLU’s first Supreme Court "
                             @"landmark established that the 14th Amendment “incorporates” the First "
                             @"Amendment’s free speech clause and therefore applies to the states.", nil) link:@""],
          [Decision decisionWithYear:1927 category:FreedomOfAssociation title:@"Whitney v. California" synopsis:
           NSLocalizedString(@"Whitney’s conviction for membership in a group advocating the overthrow " 
                             @"of the state was upheld. But Justice Brandeis laid the groundwork "
                             @"for modern First Amendment law in a separate opinion, "
                             @"in which he argued that under a “clear and present danger” test, the strong " 
                             @"presumption should be in favor of “more speech, not enforced silence.”", nil) link:@""],
          [Decision decisionWithYear:1931 category:0 title:@"Stromberg v. California" synopsis:
           NSLocalizedString(@"A California law leading to the conviction of a communist who " 
                                                                                                                 @"displayed a red flag was overturned on the grounds that the law was vague, "
                                                                                                                 @"in violation of the First Amendment.", nil) link:@""],
          [Decision decisionWithYear:1932 category:0 title:@"Powell v.Alabama" synopsis:
           NSLocalizedString(@"This appeal by the “Scottsboro Boys” – eight African Americans wrongfully " 
                             @"accused of raping two white women – was the first time constitutional "
                             @"standards were applied to state criminal proceedings.  The poor "
                             @"performance of their lawyers at the trial deprived them of their 6th Amendment "
                             @"right to effective counsel.", nil) link:@""],
          [Decision decisionWithYear:1935 category:0 title:@"Patterson v.Alabama" synopsis:
           NSLocalizedString(@"A second “Scottsboro Boys” decision held that excluding black "
                             @"people from the jury list denied defendant a fair trial.", nil) link:@""],
          [Decision decisionWithYear:1937 category:0 title:@"DeJonge v. Oregon" synopsis:
           NSLocalizedString(@"A conviction under a state criminal syndicalism statute for merely "
                             @"attending a peaceful Communist Party rally was deemed a violation of "
                             @"free speech rights.", nil) link:@""],
          [Decision decisionWithYear:1938 category:0 title:@"Lovell v. Griffin" synopsis:
           NSLocalizedString(@"In this case on behalf of Jehovah’s Witnesses, a Georgia ordinance " 
                             @"prohibiting the distribution of “literature of any kind” without a City "
                             @"Manager’s permit, was deemed a violation of religious liberty.", nil) link:@""],
          [Decision decisionWithYear:1939 category:0 title:@"Hague v. CIO" synopsis:
           NSLocalizedString(@"Invalidating the repressive actions of Jersey City’s anti-union Mayor, "
                             @"“Boss” Hague, the Supreme Court ruled that freedom of assembly "
                             @"applies to public forums, such as “streets and parks.”", nil) link:@""],
          [Decision decisionWithYear:1941 category:0 title:@"Edwards v. California" synopsis:
           NSLocalizedString(@"An “anti-Okie” law that made it a crime to transport poor people "
                             @"into California was struck down as a violation of the  right to interstate travel.", nil) link:@""],
          [Decision decisionWithYear:1943 category:0 title:@"West Virginia v. Barnette" synopsis:
           NSLocalizedString(@"Compelling Jehovah’s Witness children to salute the American flag "
                             @"against their religious beliefs was unconstitutional.", nil) link:@""],
          [Decision decisionWithYear:1944 category:0 title:@"Smith v.Allwright" synopsis:
           NSLocalizedString(@"This early civil rights victory invalidated Texas’ “white primary” as a violation " 
                             @"of the right to vote under the 15th Amendment.", nil) link:@""],
          [Decision decisionWithYear:1946 category:0 title:@"Hannegan v. Esquire" synopsis:
           NSLocalizedString(@"In a blow against censorship, this decision limited the Postmaster "
                             @"General’s power to withhold mailing privileges for magazines containing " 
                             @"“offensive” material.", nil) link:@""],
          [Decision decisionWithYear:1947 category:0 title:@"Everson v. Board of Education" synopsis:
           NSLocalizedString(@"Justice Black’s pronouncement that, “In the words of Jefferson, the "
                             @"Clause… was intended to erect a ‘wall of separation’ between church and "
                             @"State...” was the Court’s first major utterance on the meaning of the "
                             @"Establishment Clause.", nil) link:@""],
          [Decision decisionWithYear:1948 category:0 title:@"Shelley v. Kraemer" synopsis:
           NSLocalizedString(@"This major civil rights victory invalidated restrictive covenants, or " 
                             @"contractual agreements among white homeowners not to sell their houses "
                             @"to people of color.", nil) link:@""],
          [Decision decisionWithYear:1949 category:0 title:@"Terminiello v. Chicago" synopsis:
           NSLocalizedString(@"In this exoneration of a priest convicted of disorderly conduct for giving a "
                             @"racist, anti-semitic speech, Justice William O. Douglas stated, “the function " 
                             @"of free speech under our system of government is to invite dispute.”", nil) link:@""],
          [Decision decisionWithYear:1951 category:0 title:@"Kunz v. New York" synopsis:
           NSLocalizedString(@"The Supreme Court ruled that a permit to speak in a public forum could "
                             @"not be denied because a person’s speech had, on a former occasion, "
                             @"resulted in civil disorder.", nil) link:@""],
          [Decision decisionWithYear:1952 category:0 title:@"Rochin v. California" synopsis:
           NSLocalizedString(@"Reversing the conviction of a man whose stomach had been forcibly "
                             @"pumped for drugs by police, the Court ruled that the 14th Amendment’s "
                             @"Due Process Clause outlaws “conduct that shocks the conscience.”", nil) link:@""],
          [Decision decisionWithYear:1952 category:0 title:@"Burstyn v.Wilson" synopsis:
           NSLocalizedString(@"Overturning its own 1915 decision, the Supreme Court decided New "
                             @"York State’s refusal to license the film “The Miracle” because it was sacreligious " 
                             @"violated the First Amendment.", nil) link:@""],
          [Decision decisionWithYear:1954 category:0 title:@"Brown v. Board of Education" synopsis:
           NSLocalizedString(@"One of the century’s most significant Court decisions declared racially "
                             @"segregated schools unconstitutional, wiping out the “separate but equal” "
                             @"doctrine announced in the infamous 1896 Plessy v. Ferguson decision.", nil) link:@""],
          [Decision decisionWithYear:1957 category:0 title:@"Watkins v. United States" synopsis:
           NSLocalizedString(@"The investigative powers of the House UnAmerican Activities "
                             @"Committee were curbed on First Amendment grounds when the Court "
                             @"reversed a labor leader’s conviction for refusing to answer questions "
                             @"about membership in the Communist Party.", nil) link:@""],
          [Decision decisionWithYear:1958 category:0 title:@"Kent v. Dulles" synopsis:
           NSLocalizedString(@"The State Department overstepped its authority in denying a passport to "
                             @"artist Rockwell Kent, who refused to sign a “noncommunist affidavit,” "
                             @"since the right to travel is protected by the Fifth Amendment’s Due "
                             @"Process Clause.", nil) link:@""],
          [Decision decisionWithYear:1958 category:0 title:@"Speiser v. Randall" synopsis:
           NSLocalizedString(@"ACLU lawyer Lawrence Speiser successfully argued his challenge to a "
                             @"California law requiring that veterans sign a loyalty oath to qualify for a "
                             @"property tax exemption.", nil) link:@""],
          [Decision decisionWithYear:1958 category:0 title:@"Trop v. Dulles" synopsis:
           NSLocalizedString(@"Stripping an American of his citizenship for being a deserter in World "
                             @"War II was deemed cruel and unusual punishment, in violation of the "
                             @"Eighth Amendment.", nil) link:@""],
          [Decision decisionWithYear:1959 category:0 title:@"Smith v. California" synopsis:
           NSLocalizedString(@"A bookseller could not be found guilty of selling obscene material "
                             @"unless it was proven that he or she was familiar with the contents of "
                             @"the book.", nil) link:@""],
          [Decision decisionWithYear:1961 category:0 title:@"Mapp v. Ohio" synopsis:
           NSLocalizedString(@"The Fourth Amendment’s Exclusionary Rule – barring the introduction "
                             @"of illegally seized evidence in a criminal trial – first applied to federal law "
                             @"enforcement officers in 1914, applied to state and local police as well.", nil) link:@""],
          [Decision decisionWithYear:1961 category:0 title:@"Poe v. Ullman" synopsis:
           NSLocalizedString(@"This unsuccessful challenge to Connecticut’s ban on the sale of trial " 
                             @"contraceptives set the stage for  the 1965 Griswold decision. Justice John "
                             @"Harlan argued in dissent that the law was “an intolerable invasion of " 
                             @"privacy in the conduct of one of the most intimate concerns of an individual’s private life.”", nil) link:@""],
          [Decision decisionWithYear:1962 category:0 title:@"Engel v.Vitale" synopsis:
           NSLocalizedString(@"In striking down the New York State Regent’s “nondenominational” "
                             @"school prayer, the Court declared “it is no part of the business of " 
                             @"government to compose official prayers.”", nil) link:@""],
          [Decision decisionWithYear:1963 category:0 title:@"Abingdon School District v. Schempp" synopsis:
           NSLocalizedString(@"Building on Engel, the Court struck down Pennsylvania’s in-school "
                             @"Bible-reading law as a violation of the First Amendment.", nil) link:@""],
          [Decision decisionWithYear:1963 category:0 title:@"Gideon v.Wainwright" synopsis:
           NSLocalizedString(@"An indigent drifter from Florida made history when, in a handwritten "
                             @"petition, he persuaded the Court that poor people charged with a felony "
                             @"had the right to a state-appointed lawyer.", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"Escobedo v. Illinois" synopsis:
           NSLocalizedString(@"Invoking the Sixth Amendment right to counsel, the Court threw out "
                             @"the confession of a man whose repeated requests to see his lawyer, "
                             @"throughout many hours of police interrogation, were ignored.", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"New York Times v. Sullivan" synopsis:
           NSLocalizedString(@"Public officials cannot recover damages for defamation unless they "
                             @"prove a newspaper impugned them with “actual malice.” A city "
                             @"commissioner in Montgomery, Alabama sued over publication of a full-page "
                             @"ad paid for by civil rights activists.", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"Jacobellis v. Ohio" synopsis:
           NSLocalizedString(@"The Court overturned a theater owner’s conviction for showing the film "
                             @"“The Lovers,” by Louis Malle, and Justice Potter Stewart admitted that "
                             @"although he could not define “obscenity,” he “knew it when he saw it.”", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"Reynolds v. Sims" synopsis:
           NSLocalizedString(@"This historic civil rights decision, which applied the “one person, one "
                             @"vote” rule to state legislative districts, was regarded by Chief Justice Earl "
                             @"Warren as the most important decision of his tenure.", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"Baggett v. Bullitt" synopsis:
           NSLocalizedString(@"A Washington State loyalty oath required of state employees was held "
                             @"void for vagueness in violation of the First Amendment.", nil) link:@""],
          [Decision decisionWithYear:1964 category:0 title:@"Carroll v. Princess Anne County" synopsis:
           NSLocalizedString(@"A county’s decision to ban a rally without notifying the rally organizers "
                             @"of the injunction proceeding was invalidated on free speech grounds.", nil) link:@""],
          [Decision decisionWithYear:1965 category:0 title:@"U.S. v. Seeger" synopsis:
           NSLocalizedString(@"One of the first anti-Vietnam War decisions extended conscientious objector " 
                             @"status to those who do not believe in a supreme being, but who oppose "
                             @"war based on sincere beliefs that are equivalent to religious objections.", nil) link:@""],
          [Decision decisionWithYear:1965 category:0 title:@"Lamont v. Postmaster General" synopsis:
           NSLocalizedString(@"Struck down a Cold War-era law that required the Postmaster General "
                             @"to detain and destroy all unsealed mail from abroad deemed to be "
                             @"“communist political propaganda” – unless the addressee requested delivery " 
                             @"in writing.", nil) link:@""],
          [Decision decisionWithYear:1965 category:0 title:@"Griswold v. Connecticut" synopsis:
           NSLocalizedString(@"Invalidated a Connecticut law forbidding the use of contraceptives on "
                             @"the ground that a right of “marital privacy,” though not specifically "
                             @"guaranteed in the Bill of Rights, is protected by “several fundamental "
                             @"constitutional guarantees.”", nil) link:@""],
          [Decision decisionWithYear:1966 category:0 title:@"Miranda v.Arizona" synopsis:
           NSLocalizedString(@"The Court held that a suspect in police custody has a Sixth Amendment "
                             @"right to counsel and a Fifth Amendment right against self-incrimination, "
                             @"and established the “Miranda warnings” requirement that police inform "
                             @"suspects of their rights before interrogating them.", nil) link:@""],
          [Decision decisionWithYear:1966 category:0 title:@"Bond v. Floyd" synopsis:
           NSLocalizedString(@"The Georgia state legislature was ordered to seat state senator-elect Julian 
                             Bond who had been denied his seat for publicly supporting Vietnam 
                             War draft resisters. Criticizing U.S. foreign policy, said the Court, does 
                             not violate a legislator’s oath to uphold the Constitution.", nil) link:@""],
          [Decision decisionWithYear:1967 category:0 title:@"Keyishian v. Board of Regents" synopsis:
           NSLocalizedString(@"Struck down a Cold War-era law that required public school teachers to "
                             @"sign a loyalty oath. Public employment is not a “privilege” to which government " 
                             @"can attach whatever conditions it pleases. ", nil) link:@""],
          [Decision decisionWithYear:1967 category:0 title:@"In re Gault" synopsis:
           NSLocalizedString(@"Established specific due process requirements for state delinquency proceedings " 
                             @"and stated, for the first time, the broad principle that young "
                             @"persons have constitutional rights.", nil) link:@""],
          [Decision decisionWithYear:1967 category:0 title:@"Loving v.Virginia" synopsis:
           NSLocalizedString(@"Invalidated the anti-miscegenation laws of Virginia and 15 other southern " 
                             @"states. Criminal bans on interracial marriage violate the 14th "
                             @"Amendment’s Equal Protection Clause and “the freedom to marry,” "
                             @"which the Court called “one of the basic civil rights of man” (sic).", nil) link:@""],
          [Decision decisionWithYear:1967 category:0 title:@"Whitus v. Georgia" synopsis:
           NSLocalizedString(@"Successful challenge to the systematic exclusion of African Americans from "
                             @"grand and petit juries. In the county in question, no black person had ever "
                             @"served on a jury in spite of the fact that 45% of the population was black.", nil) link:@""],
          [Decision decisionWithYear:1968 category:0 title:@"Epperson v.Arkansas" synopsis:
           NSLocalizedString(@"Arkansas’ ban on teaching “that mankind ascended or descended from a "
                             @"lower order of animals” was a violation of the First Amendment, which "
                             @"forbids official religion.", nil) link:@""],
          [Decision decisionWithYear:1968 category:0 title:@"Levy v. Louisiana" synopsis:
           NSLocalizedString(@"Invalidated a state law that denied an illegitimate child the right to recover "
                             @"damages for a parent’s death. The ruling established the principle that the "
                             @"accidental circumstance of a child’s birth does not justify discrimination.", nil) link:@""],
          [Decision decisionWithYear:1968 category:0 title:@"King v. Smith" synopsis:
           NSLocalizedString(@"Invalidated the “man in the house” rule that denied welfare to children "
                             @"whose unmarried mothers lived with men. The decision benefited an estimated " 
                             @"500,000 poor children who had previously been excluded from aid.", nil) link:@""],
          [Decision decisionWithYear:1968 category:0 title:@"Washington v. Lee" synopsis:
           NSLocalizedString(@"Alabama statutes requiring racial segregation in the state’s prisons and "
                             @"jails were declared unconstitutional under the Fourteenth Amendment. ", nil) link:@""],
          [Decision decisionWithYear:1969 category:0 title:@"Brandenburg v. Ohio" synopsis:
           NSLocalizedString(@"The ACLU achieved victory in its 50-year struggle against laws punishing " 
                             @"political advocacy. The Court agreed that the government could only "
                             @"penalize direct incitement to imminent lawless action, thus invalidating "
                             @"the Smith Act and all state sedition laws.", nil) link:@""],
          [Decision decisionWithYear:1969 category:0 title:@"Tinker v. Des Moines" synopsis:
           NSLocalizedString(@"Suspending public school students for wearing black armbands to protest "
                             @"the Vietnam War was unconstitutional since students do not “shed their "
                             @"constitutional rights to freedom of speech or expression at the school-house " 
                             @"gate.”", nil) link:@""],
          [Decision decisionWithYear:1969 category:0 title:@"Gregory v. Chicago" synopsis:
           NSLocalizedString(@"The Court unanimously overturned a conviction of disorderly conduct "
                             @"against Dick Gregory and others who picketed Chicago’s Mayor Daley. "
                             @"When disorder is created by a hostile audience, peaceful demonstrators "
                             @"cannot be arrested because of a “heckler’s veto.”", nil) link:@""],
          [Decision decisionWithYear:1969 category:0 title:@"Street v. New York" synopsis:
           NSLocalizedString(@"A state law under which a man was convicted for burning the "
                             @"American flag to protest the assassination of civil rights leader Medgar "
                             @"Evers was unconstitutional.", nil) link:@""],
          [Decision decisionWithYear:1969 category:0 title:@"Watts v. U.S." synopsis:
           NSLocalizedString(@"Threats against the life of the President of the U.S., if they were no more "
                             @"than “political hyperbole,” are protected by the First Amendment.", nil) link:@""],
          [Decision decisionWithYear:1970 category:0 title:@"Goldberg v. Kelly" synopsis:
           NSLocalizedString(@"Setting in motion what has been called the “procedural due process revolution,” " 
                             @"the Court ruled that welfare recipients were entitled to notice "
                             @"and a hearing before the state could terminate their benefits.", nil) link:@""],
          [Decision decisionWithYear:1971 category:0 title:@"Cohen v. California" synopsis:
           NSLocalizedString(@"Convicting an anti-war protester of disturbing the peace for wearing a "
                             @"jacket that bore the words, “Fuck the draft,” was unconstitutional. The "
                             @"government cannot prohibit speech just because it is “offensive.”", nil) link:@""],
          [Decision decisionWithYear:1971 category:0 title:@"Organization for Better Austin v. Keefe" synopsis:
           NSLocalizedString(@"An injunction against the distribution of leaflets in an entire residential "
                             @"suburb was struck down on the grounds that the privacy interests of the "
                             @"residents did not justify such a sweeping restraint.", nil) link:@""],
          [Decision decisionWithYear:1971 category:0 title:@"U.S. v. New York Times" synopsis:
           NSLocalizedString(@"Enjoining the press from publishing the Pentagon Papers, leaked by a "
                             @"former Defense Department official, was an unconstitutional prior "
                             @"restraint which was not justified by national security interests.", nil) link:@""], 
          [Decision decisionWithYear:1971 category:0 title:@"Reed v. Reed" synopsis:
           NSLocalizedString(@"Struck down a state law that gave automatic preference to men over "
                             @"women as administrators of decedents’ estates. This was the Court’s first "
                             @"ruling that sex-based classifications violated the Equal Protection Clause "
                             @"of the 14th Amendment.", nil) link:@""], 
          [Decision decisionWithYear:1971 category:0 title:@"U.S. v. Vuitch" synopsis:
           NSLocalizedString(@"Although the Court upheld a statute used to convict a doctor who had "
                             @"performed an illegal abortion, it expanded the “life and health of the "
                             @"woman” concept to include “psychological well-being,” thereby allowing "
                             @"more women to obtain legal “therapeutic” abortions.", nil) link:@""], 
          [Decision decisionWithYear:1972 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:1972 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""], 
          [Decision decisionWithYear:0 category:0 title:@"" synopsis:NSLocalizedString(@"", nil) link:@""],  nil] retain];
    }
}

+ (NSArray*) greatestHits {
    return greatestHits;
}

@synthesize year;
@synthesize category;
@synthesize title;
@synthesize synopsis;
@synthesize link;

- (void) dealloc {
    self.year = 0;
    self.category = 0;
    self.title = nil;
    self.synopsis = nil;
    self.link = nil;
    [super dealloc];
}


- (id) initWithYear:(NSInteger) year_
           category:(Category) category_
              title:(NSString*) title_
           synopsis:(NSString*) synopsis_
               link:(NSString*) link_ {
    if (self = [super init]) {
        self.year = year_;
        self.category = category_;
        self.title = title_;
        self.synopsis = synopsis_;
        self.link = link_;
    }
    
    return self;
}


+ (Decision*) decisionWithYear:(NSInteger) year
                      category:(Category) category
                         title:(NSString*) title
                      synopsis:(NSString*) synopsis
                          link:(NSString*) link {
    return [[[Decision alloc] initWithYear:year
                                  category:category
                                     title:title
                                  synopsis:synopsis
                                      link:link] autorelease];
}

@end
