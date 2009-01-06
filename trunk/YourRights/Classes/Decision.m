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
           NSLocalizedString(@"The Georgia state legislature was ordered to seat state senator-elect Julian "
                             @"Bond who had been denied his seat for publicly supporting Vietnam "
                             @"War draft resisters. Criticizing U.S. foreign policy, said the Court, does "
                             @"not violate a legislator’s oath to uphold the Constitution.", nil) link:@""],
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
          [Decision decisionWithYear:1972 category:0 title:@"Eisenstadt v. Baird" synopsis:
           NSLocalizedString(@"In an extension of the Court’s evolving privacy doctrine, the conviction "
                             @"of a reproductive rights activist who had given an unmarried "
                             @"Massachusetts woman a contraceptive device was reversed.", nil) link:@""], 
          [Decision decisionWithYear:1972 category:0 title:@"Furman v. Georgia" synopsis:
           NSLocalizedString(@"This decision led to a four-year halt to executions nationwide when the "
                             @"Court ruled that existing state death penalty statutes were “arbitrary and "
                             @"capricious” in violation of the Eight Amendment.", nil) link:@""], 
          [Decision decisionWithYear:1973 category:0 title:@"Frontiero v. Richardson" synopsis:
           NSLocalizedString(@"Struck down a federal law that allowed a woman in the armed forces to "
                             @"claim her husband as a “dependent” only if he depended on her for more "
                             @"than half of his support, while a serviceman could claim “dependent” status " 
                             @"for his wife regardless of actual dependency.", nil) link:@""], 
          [Decision decisionWithYear:1973 category:0 title:@"Holtzman v. Schlesinger" synopsis:
           NSLocalizedString(@"The ACLU took on Rep. Elizabeth Holtzman’s lawsuit to halt the bombing " 
                             @"of Cambodia as an unconstitutional Presidential usurpation of "
                             @"Congress’ authority to declare war. Although a federal order to stop the "
                             @"bombing was eventually overturned, the bombing was halted for a few hours.", nil) link:@""], 
          [Decision decisionWithYear:1973 category:0 title:@"Roe v.Wade/Doe v. Bolton" synopsis:
           NSLocalizedString(@"Recognizing a woman’s constitutional right to terminate a pregnancy, Roe "
                             @"erased all existing criminal abortion laws. Its companion case, Doe, established " 
                             @"lished that it is the attending physician who determines, in light of all "
                             @"factors relevant to a woman’s well-being, whether an abortion is “necessary.”", nil) link:@""], 
          [Decision decisionWithYear:1974 category:0 title:@"Communist Party of Indiana v.Whitcomb" synopsis:
           NSLocalizedString(@"Invalidated a state requirement that political parties swear that they do "
                             @"not advocate the violent overthrow of government as a condition of getting " 
                             @"on the ballot.", nil) link:@""], 
          [Decision decisionWithYear:1974 category:0 title:@"Smith v. Goguen" synopsis:
           NSLocalizedString(@"A Massachusetts state law that made it a crime to treat the American flag "
                             @"“contemptuously” was found by the Court to be void for vagueness.", nil) link:@""], 
          [Decision decisionWithYear:1974 category:0 title:@"U.S. v. Nixon" synopsis:
           NSLocalizedString(@"In the only amicus brief filed in this critical case, the ACLU argued: "
                             @"“There is no proposition more dangerous to the health of a constitutional " 
                             @"democracy than the notion that an elected head of state is above the "
                             @"law and beyond the reach of judicial review.” The Court agreed, and ordered Nixon "
                             @"to hand over crucial Watergate tapes to the Special Prosecutor.", nil) link:@""], 
          [Decision decisionWithYear:1975 category:0 title:@"Goss v. Lopez" synopsis:
           NSLocalizedString(@"Invalidated a state law authorizing a public school principal to suspend " 
                             @"a student for up to ten days without a hearing. Students are entitled " 
                             @"to notice and a hearing before a significant disciplinary action can "
                             @"be taken against them.", nil) link:@""], 
          [Decision decisionWithYear:1975 category:0 title:@"O’Connor v. Donaldson" synopsis:
           NSLocalizedString(@"In its first “right to treatment” decision, the Court ruled that mental illness " 
                             @"alone did not justify “simple custodial confinement” on an indefinite " 
                             @"basis in the case of a non-violent patient who had been involuntarily "
                             @"held in a mental institution for 15 years.", nil) link:@""], 
          [Decision decisionWithYear:1976 category:0 title:@"Buckley v.Valeo" synopsis:
           NSLocalizedString(@"This challenge to the limits on campaign spending imposed by amendments " 
                             @"to the Federal Elections Campaign Act represented a partial victory " 
                             @"for free speech, as the Court struck down the Act’s restrictions on "
                             @"spending “relative to a candidate.”", nil) link:@""], 
          [Decision decisionWithYear:1977 category:0 title:@"Wooley v. Maynard" synopsis:
           NSLocalizedString(@"A New Hampshire law that prohibited a Jehovah’s Witness from covering "
                             @"up the license plate slogan “Live Free or Die” was invalidated by the Court "
                             @"as a denial of the “right not to speak.”", nil) link:@""], 
          [Decision decisionWithYear:1978 category:0 title:@"Smith v. Collin " synopsis:
           NSLocalizedString(@"A Nazi group wanted to march through a Chicago suburb, Skokie, where "
                             @"many Holocaust survivors lived. The ACLU’s controversial challenge to "
                             @"the village’s ban on the march was ultimately successful.", nil) link:@""], 
          [Decision decisionWithYear:1978 category:0 title:@"In re Primus" synopsis:
           NSLocalizedString(@"An ACLU cooperating attorney had been reprimanded for “improper "
                             @"solicitation” by the state supreme court for encouraging poor women to "
                             @"challenge the state’s sterilization of welfare recipients. The Court distinguished " 
                             @"between lawyers who solicit “for pecuniary gain” and those who do so to "
                             @"“further political and ideological goals through associational activity.”", nil) link:@""], 
          [Decision decisionWithYear:1980 category:0 title:@"Prune Yard Shopping Center v. Robins" synopsis:
           NSLocalizedString(@"Shopping mall owners appealed a California state court ruling that a "
                             @"shopping center allow distribution of political pamphlets on its premises. "
                             @"The Court rejected the owners’ property rights claim, and ruled that a "
                             @"mall was comparable to streets and sidewalks.", nil) link:@""], 
          [Decision decisionWithYear:1982 category:0 title:@"Board of Education, Island Trees School District v. Pico" synopsis:
           NSLocalizedString(@"Students successfully sued their school board on First Amendment "
                             @"grounds for removing certain “objectionable books” from the school "
                             @"library. While acknowledging a school’s right to remove material that was “pervasively " 
                             @"vulgar” or “educationally unsuitable,” the Court held that in this case, the "
                             @"students’ First Amendment “right to know” had been violated.", nil) link:@""], 
          [Decision decisionWithYear:1983 category:0 title:@"Bob Jones University v. United States" synopsis:
           NSLocalizedString(@"Two fundamentalist Christian colleges that practiced racial discrimination " 
                             @"lost their tax exempt status. The IRS can set rules enforcing a “settled " 
                             @"public policy” against racial discrimination in education.", nil) link:@""], 
          [Decision decisionWithYear:1985 category:0 title:@"Wallace v. Jaffree" synopsis:
           NSLocalizedString(@"Alabama’s “moment of silence” law, which required public school children " 
                             @"to take a moment “for meditation or voluntary prayer,” violated "
                             @"the First Amendment’s Establishment Clause.", nil) link:@""], 
          [Decision decisionWithYear:1986 category:0 title:@"Edward v.Aguillard" synopsis:
           NSLocalizedString(@"In a case reminiscent of the 1925 Scopes “monkey” trial, the Court "
                             @"struck down a Louisiana law that required public school science "
                             @"teachers to give “equal time” to so-called creation science if they "
                             @"taught students about the theory of evolution.", nil) link:@""], 
          [Decision decisionWithYear:1989 category:0 title:@"Texas v. Johnson" synopsis:
           NSLocalizedString(@"In invalidating the Texas flag desecration statute, the Court provoked "
                             @"President Bush to propose a federal ban on flag burning or mutilation. "
                             @"Congress swiftly obliged, but the Court struck down that law a year "
                             @"later in United States v. Eichman - in which the ACLU also filed a brief.", nil) link:@""], 
          [Decision decisionWithYear:1990 category:0 title:@"Cruzan v. Director of the Missouri Department of Health" synopsis:
           NSLocalizedString(@"In the Court’s first right-to-die case, the ACLU represented the family of "
                             @"a woman who had been in a persistent vegetative state for more than "
                             @"seven years. Although the Court did not go as far as the ACLU urged, it "
                             @"did recognize living wills as clear and convincing evidence of a patient’s wishes.", nil) link:@""], 
          [Decision decisionWithYear:1992 category:0 title:@"R.A.V. v.Wisconsin" synopsis:
           NSLocalizedString(@"A unanimous Court struck down as overly broad a local law banning "
                             @"the display, on public or private property, of any symbol “that arouses "
                             @"anger, alarm or resentment in others on the basis of race, color, creed, "
                             @"religion or gender.”", nil) link:@""], 
          [Decision decisionWithYear:1992 category:0 title:@"Planned Parenthood v. Casey" synopsis:
           NSLocalizedString(@"Although the Court upheld parts of Pennsylvania’s restrictive abortion "
                             @"law, it also reaffirmed the “central holding” of Roe v. Wadethat abortions "
                             @"performed prior to viability cannot be prohibited by the state.", nil) link:@""], 
          [Decision decisionWithYear:1992 category:0 title:@"Lee v.Weisman" synopsis:
           NSLocalizedString(@"The inclusion of a prayer at the beginning of a public high school graduation " 
                             @"ceremony violated the Establishment Clause.", nil) link:@""], 
          [Decision decisionWithYear:1992 category:0 title:@"Hudson v. McMillian" synopsis:
           NSLocalizedString(@"The beating of a shackled and handcuffed Louisiana prisoner was "
                             @"deemed a violation of the Eighth Amendment ban on cruel and unusual "
                             @"punishment. “Unnecessary and wanton infliction of pain” was recognized " 
                             @"as an appropriate standard in the prison context.", nil) link:@""], 
          [Decision decisionWithYear:1993 category:0 title:@"J.E.B. v.T.B." synopsis:
           NSLocalizedString(@"A prosecutor could not use peremptory challenges to disqualify potential "
                             @"jurors based solely on their gender.", nil) link:@""], 
          [Decision decisionWithYear:1993 category:0 title:@"Church of the Lukumi Babalu Aye v. Hialeah" synopsis:
           NSLocalizedString(@"A city’s ban on the ritual slaughter of animals as practiced by the "
                             @"Santeria religion was overturned as a violation of religious liberty since "
                             @"the city did permit such secular activities as hunting and fishing.", nil) link:@""], 
          [Decision decisionWithYear:1993 category:0 title:@"Wisconsin v. Mitchell" synopsis:
           NSLocalizedString(@"Wisconsin’s “hate crime” statute, providing for additional criminal "
                             @"penalties if a jury found that a defendant “intentionally selected” a victim " 
                             @"based on “race, religion, color, disability, sexual orientation, national "
                             @"origin or ancestry,” did not violate the First Amendment because the statute punished " 
                             @"acts, not thoughts or speech. ", nil) link:@""], 
          [Decision decisionWithYear:1994 category:0 title:@"Ladue v. Gilleo" synopsis:
           NSLocalizedString(@"A Missouri town’s ordinance that barred a homeowner from posting a "
                             @"sign in her bedroom window that said, “Say No to War in the Gulf – "
                             @"Call Congress Now!” was deemed to violate the First Amendment.", nil) link:@""], 
          [Decision decisionWithYear:1995 category:0 title:@"Lebron v. Amtrak" synopsis:
           NSLocalizedString(@"An artist argued successfully that Amtrak had been wrong to reject his "
                             @"billboard display because of its political message. The Court extended "
                             @"the First Amendment to corporations created by, and under the control  "
                             @"of, the government.", nil) link:@""], 
          [Decision decisionWithYear:1995 category:0 title:@"McIntyre v. Ohio Elections Commission" synopsis:
           NSLocalizedString(@"A state prohibition against the anonymous distribution of political campaign " 
                             @"literature violated the right to anonymous free speech.", nil) link:@""], 
          [Decision decisionWithYear:1995 category:0 title:@"Capitol Square Review Board v. Pinette" synopsis:
           NSLocalizedString(@"Upheld the right of the KKK to put up a cross in an area in front of the "
                             @"Ohio State Capitol building that was a traditional public forum used by "
                             @"many other groups, rejecting Ohio’s argument that allowing the display "
                             @"violated the separation of church and state.", nil) link:@""], 
          [Decision decisionWithYear:1995 category:0 title:@"Hurley v. Irish American Gay, Lesbian, and Bisexual Group of Boston" synopsis:
           NSLocalizedString(@"Upheld the right of private groups to exclude participants from their "
                             @"parades who do not share the values and message the parade sponsors "
                             @"wish to communicate.", nil) link:@""], 
          [Decision decisionWithYear:1996 category:0 title:@"Romer v. Evans" synopsis:
           NSLocalizedString(@"In this first gay rights victory, the Court invalidated a state constitutional " 
                             @"amendment, passed by public referendum in Colorado, that prohibited " 
                             @"the state and its municipalities from enacting gay rights laws.", nil) link:@""], 
          [Decision decisionWithYear:1996 category:0 title:@"Board of Commissioners v. Umbehr" synopsis:
           NSLocalizedString(@"Government contractors cannot be subjected to reprisals, such as the loss "
                             @"of a contract, for expressing their political views.", nil) link:@""], 
          [Decision decisionWithYear:1997 category:0 title:@"Reno v. ACLU" synopsis:
           NSLocalizedString(@"The Court struck down Congress’ Communications Decency Act, which "
                             @"was an attempt to censor the Internet by banning “indecent” speech, "
                             @"ruling that “the interest in encouraging freedom of expression in a democratic " 
                             @"society outweighs any theoretical but unproven benefit of censorship.”", nil) link:@""], 
          [Decision decisionWithYear:1997 category:0 title:@"Chandler v. Miller" synopsis:
           NSLocalizedString(@"Struck down a Georgia law requiring candidates for political office to "
                             @"take a urine drug test on the grounds that it violated the candidates’ "
                             @"Fourth Amendment right to privacy.", nil) link:@""], 
          [Decision decisionWithYear:1998 category:0 title:@"Bragdon v. Abbott" synopsis:
           NSLocalizedString(@"The anti-discrimination provisions of the Americans with Disabilities "
                             @"Act was interpreted to apply to persons in the early stages of HIV infection, " 
                             @"even if they did not have any overt symptoms of AIDS.", nil) link:@""], 
          [Decision decisionWithYear:1998 category:0 title:@"Oncale v. Sundowner Offshore Services" synopsis:
           NSLocalizedString(@"Title VII of the Civil Rights Act, which prohibits sexual discrimination "
                             @"and harassment in the workplace, applies to same-sex as well as opposite "
                             @"sex harassment.", nil) link:@""], 
          [Decision decisionWithYear:1999 category:0 title:@"Chicago v. Morales" synopsis:
           NSLocalizedString(@"Struck down Chicago’s anti-gang loitering law which disproportionately "
                             @"targeted African American and Latino youth who were not engaged in "
                             @"criminal activity, and resulted in the arrest of 45,000 innocent people.", nil) link:@""], 
          [Decision decisionWithYear:1999 category:0 title:@"Saenz v. Roe" synopsis:
           NSLocalizedString(@"Invalidated California’s 12-month residency requirement for welfare "
                             @"applicants new to the state as a violation of the constitutional right to "
                             @"travel, and reaffirmed the principle that citizens select states; states do "
                             @"not select citizens.", nil) link:@""], nil] retain];
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
